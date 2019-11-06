using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;

public delegate void TimerCallback(object param);

//匿名 T
class Anonymous_T
{
    public float interval;
    public int repeat;
    public TimerCallback callback;
    public object param;

    public float elapsed;
    public bool deleted;

    //interval 间隔，repeat 重复
    public void set(float interval, int repeat, TimerCallback callback, object param)
    {
        this.interval = interval;
        this.repeat = repeat;
        this.callback = callback;
        this.param = param;
    }
}


public class TimerManager : BaseManager
{

    public static int repeat;
    public static float time;

    public static bool catchCallbackExceptions = false;

    Dictionary<TimerCallback, Anonymous_T> _items;
    Dictionary<TimerCallback, Anonymous_T> _toAdd;
    List<Anonymous_T> _toRemove;
    List<Anonymous_T> _pool;

    private void Awake()
    {
        _items = new Dictionary<TimerCallback, Anonymous_T>();
        _toAdd = new Dictionary<TimerCallback, Anonymous_T>();
        _toRemove = new List<Anonymous_T>();
        _pool = new List<Anonymous_T>(100);
    }


    public void Add(float interval, int repeat, TimerCallback callback)
    {
        Add(interval, repeat, callback, null);
    }

    /**
     * @interval in seconds
     * @repeat 0 indicate loop infinitely, otherwise the run count
     **/
    public void Add(float interval, int repeat, TimerCallback callback, object callbackParam)
    {
        if (callback == null)
        {
            Debug.LogWarning("timer callback is null, " + interval + "," + repeat);
            return;
        }

        Anonymous_T t;
        if (_items.TryGetValue(callback, out t))
        {
            t.set(interval, repeat, callback, callbackParam);
            t.elapsed = 0;
            t.deleted = false;
            return;
        }

        if (_toAdd.TryGetValue(callback, out t))
        {
            t.set(interval, repeat, callback, callbackParam);
            return;
        }

        t = GetFromPool();
        t.interval = interval;
        t.repeat = repeat;
        t.callback = callback;
        t.param = callbackParam;
        _toAdd[callback] = t;
    }

    public void CallLater(TimerCallback callback)
    {
        Add(0.001f, 1, callback);
    }

    public void CallLater(TimerCallback callback, object callbackParam)
    {
        Add(0.001f, 1, callback, callbackParam);
    }

    public void AddUpdate(TimerCallback callback)
    {
        Add(0.001f, 0, callback);
    }

    public void AddUpdate(TimerCallback callback, object callbackParam)
    {
        Add(0.001f, 0, callback, callbackParam);
    }

    public void StartUnityCoroutine(IEnumerator routine)
    {
        StartCoroutine(routine);
    }

    public bool Exists(TimerCallback callback)
    {
        if (_toAdd.ContainsKey(callback))
            return true;

        Anonymous_T at;
        if (_items.TryGetValue(callback, out at))
            return !at.deleted;

        return false;
    }

    public void Remove(TimerCallback callback)
    {
        Anonymous_T t;
        if (_toAdd.TryGetValue(callback, out t))
        {
            _toAdd.Remove(callback);
            ReturnToPool(t);
        }

        if (_items.TryGetValue(callback, out t))
            t.deleted = true;
    }

    private Anonymous_T GetFromPool()
    {
        Anonymous_T t;
        int cnt = _pool.Count;
        if (cnt > 0)
        {
            t = _pool[cnt - 1];
            _pool.RemoveAt(cnt - 1);
            t.deleted = false;
            t.elapsed = 0;
        }
        else
            t = new Anonymous_T();
        return t;
    }

    private void ReturnToPool(Anonymous_T t)
    {
        t.callback = null;
        _pool.Add(t);
    }

    public void RemoveAllTiemr()
    {
        Dictionary<TimerCallback, Anonymous_T>.Enumerator iter;
        if (_items.Count > 0)
        {
            iter = _items.GetEnumerator();
            while (iter.MoveNext())
            {
                iter.Current.Value.deleted = true;
            }
        }

    }

    private void Update()
    {
        float dt = Time.unscaledDeltaTime;
        Dictionary<TimerCallback, Anonymous_T>.Enumerator iter;

        if (_items.Count > 0)
        {
            iter = _items.GetEnumerator();
            while (iter.MoveNext())
            {
                Anonymous_T i = iter.Current.Value;
                if (i.deleted)
                {
                    _toRemove.Add(i);
                    continue;
                }

                i.elapsed += dt;
                if (i.elapsed < i.interval)
                    continue;

                i.elapsed -= i.interval;
                if (i.elapsed < 0 || i.elapsed > 0.03f)
                    i.elapsed = 0;

                if (i.repeat > 0)
                {
                    i.repeat--;
                    if (i.repeat == 0)
                    {
                        i.deleted = true;
                        _toRemove.Add(i);
                    }
                }
                repeat = i.repeat;
                if (i.callback != null)
                {
                    if (catchCallbackExceptions)
                    {
                        try
                        {
                            i.callback(i.param);
                        }
                        catch (System.Exception e)
                        {
                            i.deleted = true;
                            Debug.LogWarning(" timer(internal=" + i.interval + ", repeat=" + i.repeat + ") callback error > " + e.Message);
                        }
                    }
                    else
                        i.callback(i.param);
                }
            }
            iter.Dispose();
        }

        int len = _toRemove.Count;
        if (len > 0)
        {
            for (int k = 0; k < len; k++)
            {
                Anonymous_T i = _toRemove[k];
                if (i.deleted && i.callback != null)
                {
                    _items.Remove(i.callback);
                    ReturnToPool(i);
                }
            }
            _toRemove.Clear();
        }

        if (_toAdd.Count > 0)
        {
            iter = _toAdd.GetEnumerator();
            while (iter.MoveNext())
                _items.Add(iter.Current.Key, iter.Current.Value);
            iter.Dispose();
            _toAdd.Clear();
        }
    }
}






