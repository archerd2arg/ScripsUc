class zPervScript extends UICommonAPI;//Наш класс

var ItemWindowHandle InventoryItems;//Variable Handle (llevado a trabajar con la ventana "InventoryWnd" del juego y sus elementos
var userinfo userinfo_my;//Una estructura en la que puedes poner información sobre los personajes del juego, ¡incluso la tuya!
						
var iteminfo iteminfo_my;//¡Estructura que puedes poner artículo y trabajar con ellos!
var userinfo TargetInfo_my;//Инфа моба в таргете
var RadarMapWnd Radar;//Подключаемся к скрипту RadarMapWnd

// При загрузки срипта выполним
function OnLoad() {
    InventoryItems = GetItemWindowHandle("InventoryWnd.InventoryItem"); //Obtener la manija de la ventana
    Radar = RadarMapWnd( GetScript("RadarMapWnd") );//Получить ссылку на скрипт
	OnRegisterEvent();//Функция регистрации события
	
}

//Регистрируем перехватываемые событие
function OnRegisterEvent() {
    RegisterEvent(EV_UpdateHP);//Регистрируем наш EV_UpdateHP
	RegisterEvent(EV_NotifyObject);	//Мобы на карте
}

//Функция вызывается при каком либо событие
function OnEvent(int EventID, string param) {
   if (class 'UIAPI_CHECKBOX'.static.IsChecked("zPervScript.CheckHP")) { //Если чекбокс включен   
	if (EventID == EV_NotifyObject)
	attack();//Атакуем мобов  
	if (EventID == EV_UpdateHP)//Проверим наш ли это Event
         HP();//Вызовим нашу функцию HP
            }
}

//Наша функция Атакуем мобов
function attack(){
GetTargetInfo(TargetInfo_my);//Получить инфу кто в таргете (моб)

if (TargetInfo_my.nCurHP > 0){//Если у моба хп 0
ProcessChatMessage("/attack",1);//Используем скил /attack
ProcessChatMessage("/useskill Rush Impact",1);//Используем скил /useskill Rush Impact
}else{
//AddSystemMessageString("MOB "@Radar.Name);//Имя моба
ProcessChatMessage("/target "@Radar.Name,1);//Используем скил /target
}
}

//Наша функция обработки HP
function  HP(){
local String Attacker;
//ExecuteCommand("Test Target --->" @ Attacker );//Текст в общий чат
GetPlayerInfo(userinfo_my);//Получить инфу о персонаже


//HP
    if (userinfo_my.nCurHP != userinfo_my.nMaxHP) {
        PoiskPredmeta(1539); // Вызываем функцию с поиском интема 1539 - "Банка HP" в инветоре
        if (iteminfo_my.ID.ServerID > 0){// если интем найден использум его
            RequestUseItem(iteminfo_my.ID); // пакет использовать интема
             //ProcessChatMessage("/attack",1);//Используем скил /attack
            // ProcessChatMessage("/targetnext",1);//Используем скил /targetnext
             //ProcessChatMessage("/useskill Rush Impact",1);//Используем скил /useskill Rush Impact
             }
    }

iteminfo_my.ID.ServerID = 0; //Обнуляем переменную с Id интема
}

   
   
   
// Ищим интем по id
function PoiskPredmeta(int id) {
    local ItemID FindID;//Структура наших интемов
    FindID.ClassID = id;//Передаем наш интем на поиск в переменную
    InventoryItems.GetItem(InventoryItems.FindItem(FindID), iteminfo_my);//Ищим интем в инвенторе
}


//Тут можно заполнить переменные по умолчанию (Обычно пустая)
defaultproperties {}