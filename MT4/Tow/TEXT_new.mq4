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

   ObjectCreate(0,"0",OBJ_LABEL,0,0,0);
   ObjectSetString(0,"0",OBJPROP_FONT,"Tahoma");
   ObjectSetInteger(0,"0",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"0",OBJPROP_FONTSIZE,10);
  // ObjectSetInteger(0,"0",OBJPROP_COLOR,clrAqua);
   ObjectSetString(0,"0",OBJPROP_TEXT,0,"Ask Price");
   ObjectSetInteger(0,"0",OBJPROP_XDISTANCE,120);
   ObjectSetInteger(0,"0",OBJPROP_YDISTANCE,20);
   //ObjectSetInteger(0,"0",OBJPROP_XSIZE,10);
   //ObjectSetInteger(0,"0",OBJPROP_YSIZE,10);
   
   ObjectCreate(0,"1",OBJ_LABEL,0,0,0);
   ObjectSetString(0,"1",OBJPROP_FONT,"Tahoma");
   ObjectSetInteger(0,"1",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"1",OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,"1",OBJPROP_COLOR,clrAqua);
   ObjectSetString(0,"1",OBJPROP_TEXT,0,"Ask Price");
   ObjectSetInteger(0,"1",OBJPROP_XDISTANCE,120);
   ObjectSetInteger(0,"1",OBJPROP_YDISTANCE,40);

   ObjectCreate(0,"2",OBJ_LABEL,0,0,0);
   ObjectSetString(0,"2",OBJPROP_FONT,"Tahoma");
   ObjectSetInteger(0,"2",OBJPROP_COLOR,clrAqua);
   ObjectSetInteger(0,"2",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"2",OBJPROP_FONTSIZE,10);
   ObjectSetString(0,"2",OBJPROP_TEXT,0,"Ask Price");
   ObjectSetInteger(0,"2",OBJPROP_XDISTANCE,120);
   ObjectSetInteger(0,"2",OBJPROP_YDISTANCE,60);

      ObjectCreate(0,"3",OBJ_LABEL,0,0,0);
   ObjectSetString(0,"3",OBJPROP_FONT,"Tahoma");
   ObjectSetInteger(0,"3",OBJPROP_COLOR,clrAqua);
   ObjectSetInteger(0,"3",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"3",OBJPROP_FONTSIZE,10);
   ObjectSetString(0,"3",OBJPROP_TEXT,0,"Ask Price");
   ObjectSetInteger(0,"3",OBJPROP_XDISTANCE,120);
   ObjectSetInteger(0,"3",OBJPROP_YDISTANCE,80);

   ObjectCreate(0,"4",OBJ_LABEL,0,0,0);
   ObjectSetString(0,"4",OBJPROP_FONT,"Tahoma");
   ObjectSetInteger(0,"4",OBJPROP_COLOR,clrAqua);
   ObjectSetInteger(0,"4",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"4",OBJPROP_FONTSIZE,10);
   ObjectSetString(0,"4",OBJPROP_TEXT,0,"Ask Price");
   ObjectSetInteger(0,"4",OBJPROP_XDISTANCE,120);
   ObjectSetInteger(0,"4",OBJPROP_YDISTANCE,100);




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





void OnTick(){

 

   
}
