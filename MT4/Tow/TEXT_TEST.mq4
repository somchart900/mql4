//+------------------------------------------------------------------+
//|                                                    .mq4 |
//|                         |
//|                                          |
//+------------------------------------------------------------------+
#property copyright "."
#property link      "https://www.facebook.com/huaylungcafe"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  { 
 ObjectsDeleteAll();
 ChartSetInteger(ChartID(),CHART_SHOW_PERIOD_SEP,0,0);
 ChartSetInteger(ChartID(),CHART_FOREGROUND,0,0);
 ChartSetInteger(ChartID(),CHART_SHOW_GRID,0,0);
 ChartSetInteger(ChartID(),CHART_SHIFT,0,1);
 ChartSetInteger(ChartID(),CHART_AUTOSCROLL,0,1);
 ChartSetInteger(ChartID(),CHART_MODE,CHART_CANDLES,1);
 ChartSetInteger(ChartID(),CHART_COLOR_CANDLE_BEAR,clrRed);
 ChartSetInteger(ChartID(),CHART_COLOR_CANDLE_BULL,clrLime);
 ChartSetInteger(ChartID(),CHART_COLOR_CHART_DOWN,clrRed); 
 ChartSetInteger(ChartID(),CHART_SHOW_OHLC,0,0);                             
//if(Period() != 43200){ChartSetSymbolPeriod(ChartID(),_Symbol,PERIOD_MN1);}

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   ObjectsDeleteAll();
   

   
   
   
    
  }
//+------------------------------------------------------------------+
//| Expert tick function    
                                        
void eng(){
long height = ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,0);
long width = ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0);
ObjectCreate("0", OBJ_BUTTON, 0, 0, 0);
ObjectSet("0", OBJPROP_XDISTANCE, 0);
ObjectSet("0", OBJPROP_YDISTANCE, 20);
ObjectSet("0", OBJPROP_XSIZE, 200);
ObjectSet("0", OBJPROP_YSIZE, width);
ObjectSet("0", OBJPROP_BORDER_COLOR,clrMediumBlue);
ObjectSet("0", OBJPROP_BORDER_COLOR,clrBlack);
ObjectSet("0", OBJPROP_BGCOLOR,clrBlack);
ObjectSetText("0","", 20, NULL, clrNONE);


ObjectCreate("1", OBJ_LABEL, 0, 0, 0);
ObjectSetText("1","Downtrend= %G", 10, "Tahoma",clrGreenYellow);
ObjectSet("1", OBJPROP_XDISTANCE, 1);
ObjectSet("1", OBJPROP_YDISTANCE, 20);


ObjectCreate("2", OBJ_LABEL, 0, 0, 0);
ObjectSetText("2",StringFormat("totaloder = %G",AccountEquity()), 10, "Tahoma", clrGreenYellow);
ObjectSet("2", OBJPROP_XDISTANCE,1);
ObjectSet("2", OBJPROP_YDISTANCE, 40);


ObjectCreate("3", OBJ_LABEL, 0, 0, 0);
ObjectSetText("3",StringFormat("pofitall = %G",AccountEquity()), 10,"Tahoma", clrGreenYellow);
ObjectSet("3", OBJPROP_XDISTANCE, 1);
ObjectSet("3", OBJPROP_YDISTANCE, 60);

ObjectCreate("4", OBJ_LABEL, 0, 0, 0);
ObjectSetText("4",StringFormat("pofitlastorder = %G",AccountEquity()), 10,"Tahoma", clrGreenYellow);
ObjectSet("4", OBJPROP_XDISTANCE, 1);
ObjectSet("4", OBJPROP_YDISTANCE, 80);

ObjectCreate("5", OBJ_LABEL, 0, 0, 0);
ObjectSetText("5",StringFormat("maxpofit = %G",AccountBalance()), 10,"Tahoma", clrGreenYellow);
ObjectSet("5", OBJPROP_XDISTANCE, 1);
ObjectSet("5", OBJPROP_YDISTANCE, 160);

ObjectCreate("6", OBJ_LABEL, 0, 0, 0);
ObjectSetText("6",StringFormat("curentpofit=%G",AccountEquity()), 10,"Tahoma", clrGreenYellow);
ObjectSet("6", OBJPROP_XDISTANCE, 1);
ObjectSet("6", OBJPROP_YDISTANCE, 120);


 
}

void OnTick(){

 Info();


//Comment("high "+height+"\n width "+width);
   
}
//----------------------------------------------------------------------------------------------------------

void Info(){
ObjectCreate("0", OBJ_LABEL, 0, 0, 0);
ObjectSet("0", OBJPROP_CORNER, CORNER_RIGHT_UPPER);
ObjectSetText("0","High buy "+DoubleToStr(AccountEquity(),2), 10,"Tahoma", clrGreen);
ObjectSet("0", OBJPROP_XDISTANCE, 0);
ObjectSet("0", OBJPROP_YDISTANCE, 20);

ObjectCreate("1", OBJ_LABEL, 0, 0, 0);
ObjectSet("1", OBJPROP_CORNER, CORNER_RIGHT_UPPER);
ObjectSetText("1","Now buy "+DoubleToStr(AccountEquity(),2), 10,"Tahoma", clrGreen);
ObjectSet("1", OBJPROP_XDISTANCE, 0);
ObjectSet("1", OBJPROP_YDISTANCE, 40);

ObjectCreate("3", OBJ_LABEL, 0, 0, 0);
ObjectSet("3", OBJPROP_CORNER, CORNER_RIGHT_UPPER);
ObjectSetText("3","High sell "+DoubleToStr(AccountEquity(),2), 10,"Tahoma", clrDeepPink);
ObjectSet("3", OBJPROP_XDISTANCE, 0);
ObjectSet("3", OBJPROP_YDISTANCE, 60);

ObjectCreate("4", OBJ_LABEL, 0, 0, 0);
ObjectSet("4", OBJPROP_CORNER, CORNER_RIGHT_UPPER);
ObjectSetText("4","Now sell "+DoubleToStr(AccountEquity(),2), 10,"Tahoma", clrDeepPink);
ObjectSet("4", OBJPROP_XDISTANCE, 0);
ObjectSet("4", OBJPROP_YDISTANCE, 80);

ObjectCreate("5", OBJ_LABEL, 0, 0, 0);
ObjectSet("5", OBJPROP_CORNER, CORNER_RIGHT_UPPER);
ObjectSetText("5","Total  "+DoubleToStr(AccountEquity(),2), 10,"Tahoma", clrDodgerBlue);
ObjectSet("5", OBJPROP_XDISTANCE, 0);
ObjectSet("5", OBJPROP_YDISTANCE, 100);


}
void hide_EA_name()
{
ObjectCreate("0", OBJ_BUTTON, 0, 0, 0);
ObjectSet("0", OBJPROP_XDISTANCE, 100); // start--width
ObjectSet("0", OBJPROP_YDISTANCE, 0); //--height start v v
ObjectSet("0", OBJPROP_XSIZE, 100);  //--width
ObjectSet("0", OBJPROP_YSIZE, 50);   //--height
//ObjectSet("0", OBJPROP_BORDER_COLOR,clrMediumBlue);
ObjectSet("0", OBJPROP_BORDER_COLOR,clrBlack);
ObjectSet("0", OBJPROP_BGCOLOR,clrBlack);
ObjectSetText("0","",15,NULL, clrNONE);
ObjectSet("0", OBJPROP_CORNER, CORNER_RIGHT_UPPER);
}