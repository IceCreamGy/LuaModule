#if USE_UNI_LUA
using LuaAPI = UniLua.Lua;
using RealStatePtr = UniLua.ILuaState;
using LuaCSFunction = UniLua.CSharpFunctionDelegate;
#else
using LuaAPI = XLua.LuaDLL.Lua;
using RealStatePtr = System.IntPtr;
using LuaCSFunction = XLua.LuaDLL.lua_CSFunction;
#endif

using XLua;
using System.Collections.Generic;


namespace XLua.CSObjectWrap
{
    using Utils = XLua.Utils;
    public class DGTweeningDOTweenAnimationWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(DG.Tweening.DOTweenAnimation);
			Utils.BeginObjectRegister(type, L, translator, 0, 22, 32, 32);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CreateTween", _m_CreateTween);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DOPlay", _m_DOPlay);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DOPlayBackwards", _m_DOPlayBackwards);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DOPlayForward", _m_DOPlayForward);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DOPause", _m_DOPause);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DOTogglePause", _m_DOTogglePause);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DORewind", _m_DORewind);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DORestart", _m_DORestart);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DOComplete", _m_DOComplete);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DOKill", _m_DOKill);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DOPlayById", _m_DOPlayById);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DOPlayAllById", _m_DOPlayAllById);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DOPauseAllById", _m_DOPauseAllById);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DOPlayBackwardsById", _m_DOPlayBackwardsById);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DOPlayBackwardsAllById", _m_DOPlayBackwardsAllById);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DOPlayForwardById", _m_DOPlayForwardById);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DOPlayForwardAllById", _m_DOPlayForwardAllById);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DOPlayNext", _m_DOPlayNext);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DORewindAndPlayNext", _m_DORewindAndPlayNext);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DORestartById", _m_DORestartById);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DORestartAllById", _m_DORestartAllById);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetTweens", _m_GetTweens);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "delay", _g_get_delay);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "duration", _g_get_duration);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "easeType", _g_get_easeType);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "easeCurve", _g_get_easeCurve);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "loopType", _g_get_loopType);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "loops", _g_get_loops);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "id", _g_get_id);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "isRelative", _g_get_isRelative);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "isFrom", _g_get_isFrom);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "isIndependentUpdate", _g_get_isIndependentUpdate);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "autoKill", _g_get_autoKill);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "isActive", _g_get_isActive);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "isValid", _g_get_isValid);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "target", _g_get_target);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "animationType", _g_get_animationType);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "targetType", _g_get_targetType);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "forcedTargetType", _g_get_forcedTargetType);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "autoPlay", _g_get_autoPlay);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "useTargetAsV3", _g_get_useTargetAsV3);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "endValueFloat", _g_get_endValueFloat);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "endValueV3", _g_get_endValueV3);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "endValueV2", _g_get_endValueV2);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "endValueColor", _g_get_endValueColor);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "endValueString", _g_get_endValueString);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "endValueRect", _g_get_endValueRect);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "endValueTransform", _g_get_endValueTransform);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "optionalBool0", _g_get_optionalBool0);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "optionalFloat0", _g_get_optionalFloat0);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "optionalInt0", _g_get_optionalInt0);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "optionalRotationMode", _g_get_optionalRotationMode);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "optionalScrambleMode", _g_get_optionalScrambleMode);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "optionalString", _g_get_optionalString);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "delay", _s_set_delay);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "duration", _s_set_duration);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "easeType", _s_set_easeType);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "easeCurve", _s_set_easeCurve);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "loopType", _s_set_loopType);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "loops", _s_set_loops);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "id", _s_set_id);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "isRelative", _s_set_isRelative);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "isFrom", _s_set_isFrom);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "isIndependentUpdate", _s_set_isIndependentUpdate);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "autoKill", _s_set_autoKill);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "isActive", _s_set_isActive);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "isValid", _s_set_isValid);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "target", _s_set_target);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "animationType", _s_set_animationType);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "targetType", _s_set_targetType);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "forcedTargetType", _s_set_forcedTargetType);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "autoPlay", _s_set_autoPlay);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "useTargetAsV3", _s_set_useTargetAsV3);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "endValueFloat", _s_set_endValueFloat);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "endValueV3", _s_set_endValueV3);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "endValueV2", _s_set_endValueV2);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "endValueColor", _s_set_endValueColor);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "endValueString", _s_set_endValueString);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "endValueRect", _s_set_endValueRect);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "endValueTransform", _s_set_endValueTransform);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "optionalBool0", _s_set_optionalBool0);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "optionalFloat0", _s_set_optionalFloat0);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "optionalInt0", _s_set_optionalInt0);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "optionalRotationMode", _s_set_optionalRotationMode);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "optionalScrambleMode", _s_set_optionalScrambleMode);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "optionalString", _s_set_optionalString);
            
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 2, 0, 0);
			Utils.RegisterFunc(L, Utils.CLS_IDX, "TypeToDOTargetType", _m_TypeToDOTargetType_xlua_st_);
            
			
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					DG.Tweening.DOTweenAnimation gen_ret = new DG.Tweening.DOTweenAnimation();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to DG.Tweening.DOTweenAnimation constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CreateTween(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.CreateTween(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DOPlay(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.DOPlay(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DOPlayBackwards(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.DOPlayBackwards(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DOPlayForward(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.DOPlayForward(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DOPause(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.DOPause(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DOTogglePause(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.DOTogglePause(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DORewind(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.DORewind(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DORestart(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 2&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 2)) 
                {
                    bool _fromHere = LuaAPI.lua_toboolean(L, 2);
                    
                    gen_to_be_invoked.DORestart( _fromHere );
                    
                    
                    
                    return 0;
                }
                if(gen_param_count == 1) 
                {
                    
                    gen_to_be_invoked.DORestart(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to DG.Tweening.DOTweenAnimation.DORestart!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DOComplete(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.DOComplete(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DOKill(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.DOKill(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DOPlayById(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _id = LuaAPI.lua_tostring(L, 2);
                    
                    gen_to_be_invoked.DOPlayById( _id );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DOPlayAllById(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _id = LuaAPI.lua_tostring(L, 2);
                    
                    gen_to_be_invoked.DOPlayAllById( _id );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DOPauseAllById(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _id = LuaAPI.lua_tostring(L, 2);
                    
                    gen_to_be_invoked.DOPauseAllById( _id );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DOPlayBackwardsById(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _id = LuaAPI.lua_tostring(L, 2);
                    
                    gen_to_be_invoked.DOPlayBackwardsById( _id );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DOPlayBackwardsAllById(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _id = LuaAPI.lua_tostring(L, 2);
                    
                    gen_to_be_invoked.DOPlayBackwardsAllById( _id );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DOPlayForwardById(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _id = LuaAPI.lua_tostring(L, 2);
                    
                    gen_to_be_invoked.DOPlayForwardById( _id );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DOPlayForwardAllById(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _id = LuaAPI.lua_tostring(L, 2);
                    
                    gen_to_be_invoked.DOPlayForwardAllById( _id );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DOPlayNext(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.DOPlayNext(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DORewindAndPlayNext(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.DORewindAndPlayNext(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DORestartById(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _id = LuaAPI.lua_tostring(L, 2);
                    
                    gen_to_be_invoked.DORestartById( _id );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DORestartAllById(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _id = LuaAPI.lua_tostring(L, 2);
                    
                    gen_to_be_invoked.DORestartAllById( _id );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetTweens(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                        System.Collections.Generic.List<DG.Tweening.Tween> gen_ret = gen_to_be_invoked.GetTweens(  );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_TypeToDOTargetType_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    System.Type _t = (System.Type)translator.GetObject(L, 1, typeof(System.Type));
                    
                        DG.Tweening.Core.TargetType gen_ret = DG.Tweening.DOTweenAnimation.TypeToDOTargetType( _t );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_delay(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.delay);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_duration(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.duration);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_easeType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.easeType);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_easeCurve(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.easeCurve);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_loopType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.loopType);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_loops(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.loops);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_id(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.id);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isRelative(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.isRelative);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isFrom(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.isFrom);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isIndependentUpdate(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.isIndependentUpdate);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_autoKill(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.autoKill);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isActive(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.isActive);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_isValid(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.isValid);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_target(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.target);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_animationType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.animationType);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_targetType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.targetType);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_forcedTargetType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.forcedTargetType);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_autoPlay(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.autoPlay);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_useTargetAsV3(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.useTargetAsV3);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_endValueFloat(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.endValueFloat);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_endValueV3(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                translator.PushUnityEngineVector3(L, gen_to_be_invoked.endValueV3);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_endValueV2(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                translator.PushUnityEngineVector2(L, gen_to_be_invoked.endValueV2);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_endValueColor(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                translator.PushUnityEngineColor(L, gen_to_be_invoked.endValueColor);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_endValueString(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.endValueString);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_endValueRect(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.endValueRect);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_endValueTransform(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.endValueTransform);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_optionalBool0(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.optionalBool0);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_optionalFloat0(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.optionalFloat0);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_optionalInt0(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.optionalInt0);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_optionalRotationMode(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.optionalRotationMode);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_optionalScrambleMode(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.optionalScrambleMode);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_optionalString(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushstring(L, gen_to_be_invoked.optionalString);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_delay(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.delay = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_duration(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.duration = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_easeType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                DG.Tweening.Ease gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.easeType = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_easeCurve(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.easeCurve = (UnityEngine.AnimationCurve)translator.GetObject(L, 2, typeof(UnityEngine.AnimationCurve));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_loopType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                DG.Tweening.LoopType gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.loopType = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_loops(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.loops = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_id(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.id = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_isRelative(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.isRelative = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_isFrom(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.isFrom = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_isIndependentUpdate(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.isIndependentUpdate = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_autoKill(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.autoKill = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_isActive(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.isActive = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_isValid(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.isValid = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_target(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.target = (UnityEngine.Component)translator.GetObject(L, 2, typeof(UnityEngine.Component));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_animationType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                DG.Tweening.Core.DOTweenAnimationType gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.animationType = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_targetType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                DG.Tweening.Core.TargetType gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.targetType = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_forcedTargetType(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                DG.Tweening.Core.TargetType gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.forcedTargetType = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_autoPlay(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.autoPlay = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_useTargetAsV3(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.useTargetAsV3 = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_endValueFloat(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.endValueFloat = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_endValueV3(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                UnityEngine.Vector3 gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.endValueV3 = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_endValueV2(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                UnityEngine.Vector2 gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.endValueV2 = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_endValueColor(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                UnityEngine.Color gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.endValueColor = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_endValueString(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.endValueString = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_endValueRect(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                UnityEngine.Rect gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.endValueRect = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_endValueTransform(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.endValueTransform = (UnityEngine.Transform)translator.GetObject(L, 2, typeof(UnityEngine.Transform));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_optionalBool0(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.optionalBool0 = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_optionalFloat0(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.optionalFloat0 = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_optionalInt0(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.optionalInt0 = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_optionalRotationMode(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                DG.Tweening.RotateMode gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.optionalRotationMode = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_optionalScrambleMode(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                DG.Tweening.ScrambleMode gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.optionalScrambleMode = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_optionalString(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                DG.Tweening.DOTweenAnimation gen_to_be_invoked = (DG.Tweening.DOTweenAnimation)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.optionalString = LuaAPI.lua_tostring(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
