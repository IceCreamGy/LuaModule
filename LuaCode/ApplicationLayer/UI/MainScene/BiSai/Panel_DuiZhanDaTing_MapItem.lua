
local Panel_DuiZhanDaTing_MapItem = Class("Panel_DuiZhanDaTing_MapItem")

function Panel_DuiZhanDaTing_MapItem:ctor(GoParam, uitableParam, dataParam)
    self.Go = GoParam
    self.uitable = uitableParam
    self.data = dataParam

    self.uitable.ImagePro_MapBg:SetImage(self.data.MapSelectBg)         --背景
    self.uitable.Text_MapName.text = self.data.MapName      --地图名字
    self.uitable.Text_MapStar.text = self.data.MapStar      --地图星级
    self.uitable.ImagePro_Container.CG.alpha = 0

    --设置驾照
    if self.data.License > DataManager.GetPlayerInfo().License then
        self.uitable.ImagePro_Lock.gameObject:SetActive(true)
        self.uitable.Text_License.text = self.data.LicenseExplain
    else
        self.uitable.ImagePro_Lock.gameObject:SetActive(false)
    end
end

function Panel_DuiZhanDaTing_MapItem.PlayTween(item)
    --出场动画
    item.uitable.ImagePro_Container.CG.alpha = 0
    item.uitable.ImagePro_Container.CG:DOFade(1, 0.3)
    item.uitable.ImagePro_Container.RT.anchoredPosition = Vector2(200, 0)
    item.uitable.ImagePro_Container.RT:DOAnchorPos(Vector2(0, 0), 0.3)
end

function Panel_DuiZhanDaTing_MapItem.PlayTweenOnlyCG(item)
    --出场动画
    item.uitable.ImagePro_Container.CG.alpha = 0
    item.uitable.ImagePro_Container.CG:DOFade(1, 0.6)
    item.uitable.ImagePro_Container.Rt.rotation=Quaternion.Euler(0,-60,0)
    item.uitable.ImagePro_Container.Rt:DORotate(Vector3.zero, 0.6);
end

function Panel_DuiZhanDaTing_MapItem.Hide(item)
    item.uitable.ImagePro_Container.CG.alpha = 0
end


return Panel_DuiZhanDaTing_MapItem