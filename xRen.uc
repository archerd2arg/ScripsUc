//Авто HP CP MP, Авто атака и тп.
class xRen extends UICommonAPI;

var userinfo userinfo_my;//Структура в которую можно положить инфу о персонажах в игре в том числе и о своем!
var iteminfo iteminfo_my;//Структура можно положить item и работать  с ними!
var ItemWindowHandle InventoryItems;//Переменная Handle (беретсяокна для работы с окном "InventoryWnd" игры и его элементами)
var Array < string > Maps;//Массив с элементами из ini файла

// При загрузки срипта выполним
function OnLoad() {
    InventoryItems = GetItemWindowHandle("InventoryWnd.InventoryItem"); //Получаем Handle окна
    OnRegisterEvent();
    GetINIString_my();
}

//Читаем из ini файла наши настроки
function GetINIString_my() {
    local string Skill;
    local int Count;
    local int i;

    RefreshINI("Mod.ini"); //Перезагрузим ini (нужно если менять данные в ini во время игры)

    GetINIInt("CountSection", "Count", Count, "Mod.ini");
    AddSystemMessageString("Count" @ Count); //Текст в чат что Count
    for (i = 0; i < Count; i++) {
	GetINIString("SkillSection", "Skill" $i, Skill, "Mod.ini");
        Maps[i] = Skill;
        // AddSystemMessageString("Skillarr" @ Maps[i]); //Текст в чат наш массив
    }

    //Split( Skill, "/", Maps); Скопировать после символа

    //SetINIString("global", "Keyword2", script.m_Keyword2, "chatfilter.ini"); //Запись в ini

}

//Обработка чекбоксов
function OnClickCheckBox(String strID) {

    if (strID == "CheckCPHPMP" && class 'UIAPI_CHECKBOX'.static.IsChecked("xRen.CheckCPHPMP")) {

    }
}

//Обработка нажатия кнопок
function OnClickButton(string strID) {
    if (strID == "relod")
        GetINIString_my();//Читаем из ini

}

//Регистрируем перехватываемые событие
function OnRegisterEvent() {
    RegisterEvent(EV_UpdateCP);
    RegisterEvent(EV_UpdateHP);
    RegisterEvent(EV_UpdateMP);
    RegisterEvent(EV_NotifyObject);
	RegisterEvent(EV_TargetUpdate);
}

//Функция вызывается при каком либо событие
function OnEvent(int EventID, string param) {
    if (class 'UIAPI_CHECKBOX'.static.IsChecked("xRen.CheckCPHPMP")) { //Если чекбокс включен	
        if (EventID == EV_UpdateCP)
            CheckHPCPMP();
        if (EventID == EV_UpdateHP)
            CheckHPCPMP();
        if (EventID == EV_UpdateMP)
            CheckHPCPMP();
        if (EventID == EV_NotifyObject)//Если на радаре есть мобы отловим
            AutoAttach(); //Автоатака
			    if (EventID == EV_TargetUpdate)//Таргет
            Target(); //Автоатака
    }

}

function Target(){
GetPlayerInfo(userinfo_my);//Получить инфу о персонаже
	//AddSystemMessageString("bNpc"@userinfo_my.bNpc);
	//AddSystemMessageString("Loc"@userinfo_my.Loc);

}
//Автоатака (не забывать вкличить отоброжение мобов на радаре в игре верхний угол)
function AutoAttach() {
    local userinfo TargetInfo_my;
    local int i;
    GetTargetInfo(TargetInfo_my);

    for (i = 0; i < Maps.length; i++) {
        if ((TargetInfo_my.nCurHP > 0) && (Maps[i] == "/attack")) {
            ProcessChatMessage(Maps[i], 1);
        } else {
            ProcessChatMessage(Maps[i], 1);
        }
    }
}


//Функция авто HP CP MP
function CheckHPCPMP() {

    GetPlayerInfo(userinfo_my); // polychenie userinfo_my svoego personaja
    // ProcessChatMessage("/useskill Prominence", 1);//Юзаем скил через макрос

    //СP
    if (userinfo_my.nCurCP != userinfo_my.nMaxCP) {
        PoiskPredmeta(5592); // Вызываем функцию с поиском интема в инветоре
        if (iteminfo_my.ID.ServerID > 0) // если интем найден использум его
            RequestUseItem(iteminfo_my.ID); // packet na use banki
    }
    //HP
    if (userinfo_my.nCurHP != userinfo_my.nMaxHP) {
        PoiskPredmeta(1539); // Вызываем функцию с поиском интема в инветоре
        if (iteminfo_my.ID.ServerID > 0) // если интем найден использум его
            RequestUseItem(iteminfo_my.ID); // packet na use banki
    }
    //MP
    if (userinfo_my.nCurMP < 1000) {
        PoiskPredmeta(728); // Вызываем функцию с поиском интема в инветоре
        if (iteminfo_my.ID.ServerID > 0) // если интем найден использум его
            RequestUseItem(iteminfo_my.ID); // packet na use banki
    }
	
    iteminfo_my.ID.ServerID = 0; //Обнуляем переменную с Id интема
}

// Ищим интем по id
function PoiskPredmeta(int id) {
    local ItemID FindID;
    FindID.ClassID = id;
    InventoryItems.GetItem(InventoryItems.FindItem(FindID), iteminfo_my);
}


defaultproperties {}