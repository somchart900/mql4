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
EventSetMillisecondTimer(1000);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
 EventKillTimer();
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
ObjectSet("0", OBJPROP_XSIZE, width);
ObjectSet("0", OBJPROP_YSIZE, height);
ObjectSet("0", OBJPROP_BORDER_COLOR,clrMediumBlue);
ObjectSet("0", OBJPROP_BORDER_COLOR,clrBlack);
ObjectSet("0", OBJPROP_BGCOLOR,clrBlack);
ObjectSetText("0","", 10, NULL, clrNONE);

ObjectCreate("C1L1", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C1L1", OBJPROP_XDISTANCE, 1);
ObjectSet("C1L1", OBJPROP_YDISTANCE, 20);
ObjectSet("C1L1", OBJPROP_XSIZE, 801);
ObjectSet("C1L1", OBJPROP_YSIZE, 40);
ObjectSet("C1L1", OBJPROP_BGCOLOR,clrDarkGreen);
ObjectSetText("C1L1","", 10,NULL, clrNONE);

ObjectCreate("C1L1_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C1L1_T","HELLO WORLD   "+AccountServer(), 15,"Tahoma", clrWhite);
ObjectSet("C1L1_T", OBJPROP_XDISTANCE, 30);
ObjectSet("C1L1_T", OBJPROP_YDISTANCE, 30);


ObjectCreate("C2L1", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C2L1", OBJPROP_XDISTANCE, 1);
ObjectSet("C2L1", OBJPROP_YDISTANCE, 60);
ObjectSet("C2L1", OBJPROP_XSIZE, 100);
ObjectSet("C2L1", OBJPROP_YSIZE, 20);
ObjectSet("C2L1", OBJPROP_BGCOLOR,clrDarkViolet);
ObjectSetText("C2L1","",10,NULL, clrNONE);

ObjectCreate("C2L1_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C2L1_T","SYMBOL", 8,"Tahoma", clrWhite);
ObjectSet("C2L1_T", OBJPROP_XDISTANCE, 20);
ObjectSet("C2L1_T", OBJPROP_YDISTANCE, 62);

ObjectCreate("C2L2", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C2L2", OBJPROP_XDISTANCE, 101);
ObjectSet("C2L2", OBJPROP_YDISTANCE, 60);
ObjectSet("C2L2", OBJPROP_XSIZE, 100);
ObjectSet("C2L2", OBJPROP_YSIZE, 20);
ObjectSet("C2L2", OBJPROP_BGCOLOR,clrDarkViolet);
ObjectSetText("C2L2","",10,NULL, clrNONE);

ObjectCreate("C2L2_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C2L2_T","CurrentSpread", 8,"Tahoma", clrWhite);
ObjectSet("C2L2_T", OBJPROP_XDISTANCE, 117);
ObjectSet("C2L2_T", OBJPROP_YDISTANCE, 62);

ObjectCreate("C2L3", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C2L3", OBJPROP_XDISTANCE, 201);
ObjectSet("C2L3", OBJPROP_YDISTANCE, 60);
ObjectSet("C2L3", OBJPROP_XSIZE, 100);
ObjectSet("C2L3", OBJPROP_YSIZE, 20);
ObjectSet("C2L3", OBJPROP_BGCOLOR,clrDarkViolet);
ObjectSetText("C2L3","",10,NULL, clrNONE);

ObjectCreate("C2L3_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C2L3_T","AllowSpread", 8,"Tahoma", clrWhite);
ObjectSet("C2L3_T", OBJPROP_XDISTANCE, 217);
ObjectSet("C2L3_T", OBJPROP_YDISTANCE, 62);

ObjectCreate("C2L4", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C2L4", OBJPROP_XDISTANCE, 301);
ObjectSet("C2L4", OBJPROP_YDISTANCE, 60);
ObjectSet("C2L4", OBJPROP_XSIZE, 100);
ObjectSet("C2L4", OBJPROP_YSIZE, 20);
ObjectSet("C2L4", OBJPROP_BGCOLOR,clrDarkViolet);
ObjectSetText("C2L4","",10,NULL, clrNONE);

ObjectCreate("C2L4_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C2L4_T","Opening", 8,"Tahoma", clrWhite);
ObjectSet("C2L4_T", OBJPROP_XDISTANCE, 325);
ObjectSet("C2L4_T", OBJPROP_YDISTANCE, 62);

ObjectCreate("C2L5", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C2L5", OBJPROP_XDISTANCE, 401);
ObjectSet("C2L5", OBJPROP_YDISTANCE, 60);
ObjectSet("C2L5", OBJPROP_XSIZE, 100);
ObjectSet("C2L5", OBJPROP_YSIZE, 20);
ObjectSet("C2L5", OBJPROP_BGCOLOR,clrDarkViolet);
ObjectSetText("C2L5","",10,NULL, clrNONE);

ObjectCreate("C2L5_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C2L5_T","VolumeSize", 8,"Tahoma", clrWhite);
ObjectSet("C2L5_T", OBJPROP_XDISTANCE, 425);
ObjectSet("C2L5_T", OBJPROP_YDISTANCE, 62);

ObjectCreate("C2L6", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C2L6", OBJPROP_XDISTANCE, 501);
ObjectSet("C2L6", OBJPROP_YDISTANCE, 60);
ObjectSet("C2L6", OBJPROP_XSIZE, 100);
ObjectSet("C2L6", OBJPROP_YSIZE, 20);
ObjectSet("C2L6", OBJPROP_BGCOLOR,clrDarkViolet);
ObjectSetText("C2L6","",10,NULL, clrNONE);

ObjectCreate("C2L6_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C2L6_T","SymbolProfit", 8,"Tahoma", clrWhite);
ObjectSet("C2L6_T", OBJPROP_XDISTANCE, 525);
ObjectSet("C2L6_T", OBJPROP_YDISTANCE, 62);

ObjectCreate("C2L7", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C2L7", OBJPROP_XDISTANCE, 601);
ObjectSet("C2L7", OBJPROP_YDISTANCE, 60);
ObjectSet("C2L7", OBJPROP_XSIZE, 100);
ObjectSet("C2L7", OBJPROP_YSIZE, 20);
ObjectSet("C2L7", OBJPROP_BGCOLOR,clrDarkViolet);
ObjectSetText("C2L7","",10,NULL, clrNONE);

ObjectCreate("C2L7_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C2L7_T","Maximum", 8,"Tahoma", clrWhite);
ObjectSet("C2L7_T", OBJPROP_XDISTANCE, 625);
ObjectSet("C2L7_T", OBJPROP_YDISTANCE, 62);

ObjectCreate("C2L8", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C2L8", OBJPROP_XDISTANCE, 701);
ObjectSet("C2L8", OBJPROP_YDISTANCE, 60);
ObjectSet("C2L8", OBJPROP_XSIZE, 100);
ObjectSet("C2L8", OBJPROP_YSIZE, 20);
ObjectSet("C2L8", OBJPROP_BGCOLOR,clrDarkViolet);
ObjectSetText("C2L8","",10,NULL, clrNONE);

ObjectCreate("C2L8_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C2L8_T","Last", 8,"Tahoma", clrWhite);
ObjectSet("C2L8_T", OBJPROP_XDISTANCE, 725);
ObjectSet("C2L8_T", OBJPROP_YDISTANCE, 62);

//+-------------- -----------------------------------------------------------------------------------------------------------End Header
ObjectCreate("C3L1", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C3L1", OBJPROP_XDISTANCE, 1);
ObjectSet("C3L1", OBJPROP_YDISTANCE, 80);
ObjectSet("C3L1", OBJPROP_XSIZE, 100);
ObjectSet("C3L1", OBJPROP_YSIZE, 20);
ObjectSet("C3L1", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C3L1","",10,NULL, clrNONE);

ObjectCreate("C3L1_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C3L1_T","EURUSD", 8,"Tahoma", clrWhite);
ObjectSet("C3L1_T", OBJPROP_XDISTANCE, 20);
ObjectSet("C3L1_T", OBJPROP_YDISTANCE, 82);

ObjectCreate("C3L2", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C3L2", OBJPROP_XDISTANCE, 101);
ObjectSet("C3L2", OBJPROP_YDISTANCE, 80);
ObjectSet("C3L2", OBJPROP_XSIZE, 100);
ObjectSet("C3L2", OBJPROP_YSIZE, 20);
ObjectSet("C3L2", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C3L2","",10,NULL, clrNONE);

ObjectCreate("C3L2_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C3L2_T","15 Pionts", 8,"Tahoma", clrWhite);
ObjectSet("C3L2_T", OBJPROP_XDISTANCE, 117);
ObjectSet("C3L2_T", OBJPROP_YDISTANCE, 82);

ObjectCreate("C3L3", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C3L3", OBJPROP_XDISTANCE, 201);
ObjectSet("C3L3", OBJPROP_YDISTANCE, 80);
ObjectSet("C3L3", OBJPROP_XSIZE, 100);
ObjectSet("C3L3", OBJPROP_YSIZE, 20);
ObjectSet("C3L3", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C3L3","",10,NULL, clrNONE);

ObjectCreate("C3L3_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C3L3_T","15  Pionts", 8,"Tahoma", clrWhite);
ObjectSet("C3L3_T", OBJPROP_XDISTANCE, 217);
ObjectSet("C3L3_T", OBJPROP_YDISTANCE, 82);

ObjectCreate("C3L4", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C3L4", OBJPROP_XDISTANCE, 301);
ObjectSet("C3L4", OBJPROP_YDISTANCE, 80);
ObjectSet("C3L4", OBJPROP_XSIZE, 100);
ObjectSet("C3L4", OBJPROP_YSIZE, 20);
ObjectSet("C3L4", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C3L4","",10,NULL, clrNONE);

ObjectCreate("C3L4_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C3L4_T","1  Posistions", 8,"Tahoma", clrWhite);
ObjectSet("C3L4_T", OBJPROP_XDISTANCE, 325);
ObjectSet("C3L4_T", OBJPROP_YDISTANCE, 82);

ObjectCreate("C3L5", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C3L5", OBJPROP_XDISTANCE, 401);
ObjectSet("C3L5", OBJPROP_YDISTANCE, 80);
ObjectSet("C3L5", OBJPROP_XSIZE, 100);
ObjectSet("C3L5", OBJPROP_YSIZE, 20);
ObjectSet("C3L5", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C3L5","",10,NULL, clrNONE);

ObjectCreate("C3L5_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C3L5_T","0.10  Lots", 8,"Tahoma", clrWhite);
ObjectSet("C3L5_T", OBJPROP_XDISTANCE, 425);
ObjectSet("C3L5_T", OBJPROP_YDISTANCE, 82);

ObjectCreate("C3L6", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C3L6", OBJPROP_XDISTANCE, 501);
ObjectSet("C3L6", OBJPROP_YDISTANCE, 80);
ObjectSet("C3L6", OBJPROP_XSIZE, 100);
ObjectSet("C3L6", OBJPROP_YSIZE, 20);
ObjectSet("C3L6", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C2L6","",10,NULL, clrNONE);

ObjectCreate("C3L6_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C3L6_T","0.00 "+AccountCurrency(), 8,"Tahoma", clrWhite);
ObjectSet("C3L6_T", OBJPROP_XDISTANCE, 525);
ObjectSet("C3L6_T", OBJPROP_YDISTANCE, 82);

ObjectCreate("C3L7", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C3L7", OBJPROP_XDISTANCE, 601);
ObjectSet("C3L7", OBJPROP_YDISTANCE, 80);
ObjectSet("C3L7", OBJPROP_XSIZE, 100);
ObjectSet("C3L7", OBJPROP_YSIZE, 20);
ObjectSet("C3L7", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C2L7","",10,NULL, clrNONE);

ObjectCreate("C3L7_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C3L7_T","0.00 "+AccountCurrency(), 8,"Tahoma", clrWhite);
ObjectSet("C3L7_T", OBJPROP_XDISTANCE, 625);
ObjectSet("C3L7_T", OBJPROP_YDISTANCE, 82);

ObjectCreate("C3L8", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C3L8", OBJPROP_XDISTANCE, 701);
ObjectSet("C3L8", OBJPROP_YDISTANCE, 80);
ObjectSet("C3L8", OBJPROP_XSIZE, 100);
ObjectSet("C3L8", OBJPROP_YSIZE, 20);
ObjectSet("C3L8", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C3L8","",10,NULL, clrNONE);

ObjectCreate("C3L8_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C3L8_T","0.00 "+AccountCurrency(), 8,"Tahoma", clrWhite);
ObjectSet("C3L8_T", OBJPROP_XDISTANCE, 725);
ObjectSet("C3L8_T", OBJPROP_YDISTANCE, 82);

//+------------------------------------------------------------------------------------------------------------------------------- End Symbol 1

ObjectCreate("C4L1", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C4L1", OBJPROP_XDISTANCE, 1);
ObjectSet("C4L1", OBJPROP_YDISTANCE, 100);
ObjectSet("C4L1", OBJPROP_XSIZE, 100);
ObjectSet("C4L1", OBJPROP_YSIZE, 20);
ObjectSet("C4L1", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C4L1","",10,NULL, clrNONE);

ObjectCreate("C4L1_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C4L1_T","Symbol2", 8,"Tahoma", clrWhite);
ObjectSet("C4L1_T", OBJPROP_XDISTANCE, 20);
ObjectSet("C4L1_T", OBJPROP_YDISTANCE, 102);

ObjectCreate("C4L2", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C4L2", OBJPROP_XDISTANCE, 101);
ObjectSet("C4L2", OBJPROP_YDISTANCE, 100);
ObjectSet("C4L2", OBJPROP_XSIZE, 100);
ObjectSet("C4L2", OBJPROP_YSIZE, 20);
ObjectSet("C4L2", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C4L2","",10,NULL, clrNONE);

ObjectCreate("C4L2_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C4L2_T","15 Pionts", 8,"Tahoma", clrWhite);
ObjectSet("C4L2_T", OBJPROP_XDISTANCE, 117);
ObjectSet("C4L2_T", OBJPROP_YDISTANCE, 102);

ObjectCreate("C4L3", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C4L3", OBJPROP_XDISTANCE, 201);
ObjectSet("C4L3", OBJPROP_YDISTANCE, 100);
ObjectSet("C4L3", OBJPROP_XSIZE, 100);
ObjectSet("C4L3", OBJPROP_YSIZE, 20);
ObjectSet("C4L3", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C4L3","",10,NULL, clrNONE);

ObjectCreate("C4L3_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C4L3_T","15  Pionts", 8,"Tahoma", clrWhite);
ObjectSet("C4L3_T", OBJPROP_XDISTANCE, 217);
ObjectSet("C4L3_T", OBJPROP_YDISTANCE, 102);

ObjectCreate("C4L4", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C4L4", OBJPROP_XDISTANCE, 301);
ObjectSet("C4L4", OBJPROP_YDISTANCE, 100);
ObjectSet("C4L4", OBJPROP_XSIZE, 100);
ObjectSet("C4L4", OBJPROP_YSIZE, 20);
ObjectSet("C4L4", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C4L4","",10,NULL, clrNONE);

ObjectCreate("C4L4_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C4L4_T","1  Posistions", 8,"Tahoma", clrWhite);
ObjectSet("C4L4_T", OBJPROP_XDISTANCE, 325);
ObjectSet("C4L4_T", OBJPROP_YDISTANCE, 102);

ObjectCreate("C4L5", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C4L5", OBJPROP_XDISTANCE, 401);
ObjectSet("C4L5", OBJPROP_YDISTANCE, 100);
ObjectSet("C4L5", OBJPROP_XSIZE, 100);
ObjectSet("C4L5", OBJPROP_YSIZE, 20);
ObjectSet("C4L5", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C4L5","",10,NULL, clrNONE);

ObjectCreate("C4L5_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C4L5_T","0.10  Lots", 8,"Tahoma", clrWhite);
ObjectSet("C4L5_T", OBJPROP_XDISTANCE, 425);
ObjectSet("C4L5_T", OBJPROP_YDISTANCE, 102);

ObjectCreate("C4L6", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C4L6", OBJPROP_XDISTANCE, 501);
ObjectSet("C4L6", OBJPROP_YDISTANCE, 100);
ObjectSet("C4L6", OBJPROP_XSIZE, 100);
ObjectSet("C4L6", OBJPROP_YSIZE, 20);
ObjectSet("C4L6", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C2L6","",10,NULL, clrNONE);

ObjectCreate("C4L6_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C4L6_T","0.00 "+AccountCurrency(), 8,"Tahoma", clrWhite);
ObjectSet("C4L6_T", OBJPROP_XDISTANCE, 525);
ObjectSet("C4L6_T", OBJPROP_YDISTANCE, 102);

ObjectCreate("C4L7", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C4L7", OBJPROP_XDISTANCE, 601);
ObjectSet("C4L7", OBJPROP_YDISTANCE, 100);
ObjectSet("C4L7", OBJPROP_XSIZE, 100);
ObjectSet("C4L7", OBJPROP_YSIZE, 20);
ObjectSet("C4L7", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C2L7","",10,NULL, clrNONE);

ObjectCreate("C4L7_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C4L7_T","0.00 "+AccountCurrency(), 8,"Tahoma", clrWhite);
ObjectSet("C4L7_T", OBJPROP_XDISTANCE, 625);
ObjectSet("C4L7_T", OBJPROP_YDISTANCE, 102);

ObjectCreate("C4L8", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C4L8", OBJPROP_XDISTANCE, 701);
ObjectSet("C4L8", OBJPROP_YDISTANCE, 100);
ObjectSet("C4L8", OBJPROP_XSIZE, 100);
ObjectSet("C4L8", OBJPROP_YSIZE, 20);
ObjectSet("C4L8", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C4L8","",10,NULL, clrNONE);

ObjectCreate("C4L8_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C4L8_T","0.00 "+AccountCurrency(), 8,"Tahoma", clrWhite);
ObjectSet("C4L8_T", OBJPROP_XDISTANCE, 725);
ObjectSet("C4L8_T", OBJPROP_YDISTANCE, 102);

//+----------------------------------------------------------------------------------------------------------------------- End Symbol 2
ObjectCreate("C5L1", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C5L1", OBJPROP_XDISTANCE, 1);
ObjectSet("C5L1", OBJPROP_YDISTANCE, 120);
ObjectSet("C5L1", OBJPROP_XSIZE, 100);
ObjectSet("C5L1", OBJPROP_YSIZE, 20);
ObjectSet("C5L1", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C5L1","",10,NULL, clrNONE);

ObjectCreate("C5L1_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C5L1_T","Symbol2", 8,"Tahoma", clrWhite);
ObjectSet("C5L1_T", OBJPROP_XDISTANCE, 20);
ObjectSet("C5L1_T", OBJPROP_YDISTANCE, 122);

ObjectCreate("C5L2", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C5L2", OBJPROP_XDISTANCE, 101);
ObjectSet("C5L2", OBJPROP_YDISTANCE, 120);
ObjectSet("C5L2", OBJPROP_XSIZE, 100);
ObjectSet("C5L2", OBJPROP_YSIZE, 20);
ObjectSet("C5L2", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C5L2","",10,NULL, clrNONE);

ObjectCreate("C5L2_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C5L2_T","15 Pionts", 8,"Tahoma", clrWhite);
ObjectSet("C5L2_T", OBJPROP_XDISTANCE, 117);
ObjectSet("C5L2_T", OBJPROP_YDISTANCE, 122);

ObjectCreate("C5L3", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C5L3", OBJPROP_XDISTANCE, 201);
ObjectSet("C5L3", OBJPROP_YDISTANCE, 120);
ObjectSet("C5L3", OBJPROP_XSIZE, 100);
ObjectSet("C5L3", OBJPROP_YSIZE, 20);
ObjectSet("C5L3", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C5L3","",10,NULL, clrNONE);

ObjectCreate("C5L3_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C5L3_T","15  Pionts", 8,"Tahoma", clrWhite);
ObjectSet("C5L3_T", OBJPROP_XDISTANCE, 217);
ObjectSet("C5L3_T", OBJPROP_YDISTANCE, 122);

ObjectCreate("C5L4", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C5L4", OBJPROP_XDISTANCE, 301);
ObjectSet("C5L4", OBJPROP_YDISTANCE, 120);
ObjectSet("C5L4", OBJPROP_XSIZE, 100);
ObjectSet("C5L4", OBJPROP_YSIZE, 20);
ObjectSet("C5L4", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C5L4","",10,NULL, clrNONE);

ObjectCreate("C5L4_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C5L4_T","1  Posistions", 8,"Tahoma", clrWhite);
ObjectSet("C5L4_T", OBJPROP_XDISTANCE, 325);
ObjectSet("C5L4_T", OBJPROP_YDISTANCE, 122);

ObjectCreate("C5L5", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C5L5", OBJPROP_XDISTANCE, 401);
ObjectSet("C5L5", OBJPROP_YDISTANCE, 120);
ObjectSet("C5L5", OBJPROP_XSIZE, 100);
ObjectSet("C5L5", OBJPROP_YSIZE, 20);
ObjectSet("C5L5", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C5L5","",10,NULL, clrNONE);

ObjectCreate("C5L5_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C5L5_T","0.10  Lots", 8,"Tahoma", clrWhite);
ObjectSet("C5L5_T", OBJPROP_XDISTANCE, 425);
ObjectSet("C5L5_T", OBJPROP_YDISTANCE, 122);

ObjectCreate("C5L6", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C5L6", OBJPROP_XDISTANCE, 501);
ObjectSet("C5L6", OBJPROP_YDISTANCE, 120);
ObjectSet("C5L6", OBJPROP_XSIZE, 100);
ObjectSet("C5L6", OBJPROP_YSIZE, 20);
ObjectSet("C5L6", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C2L6","",10,NULL, clrNONE);

ObjectCreate("C5L6_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C5L6_T","0.00 "+AccountCurrency(), 8,"Tahoma", clrWhite);
ObjectSet("C5L6_T", OBJPROP_XDISTANCE, 525);
ObjectSet("C5L6_T", OBJPROP_YDISTANCE, 122);

ObjectCreate("C5L7", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C5L7", OBJPROP_XDISTANCE, 601);
ObjectSet("C5L7", OBJPROP_YDISTANCE, 120);
ObjectSet("C5L7", OBJPROP_XSIZE, 100);
ObjectSet("C5L7", OBJPROP_YSIZE, 20);
ObjectSet("C5L7", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C2L7","",10,NULL, clrNONE);

ObjectCreate("C5L7_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C5L7_T","0.00 "+AccountCurrency(), 8,"Tahoma", clrWhite);
ObjectSet("C5L7_T", OBJPROP_XDISTANCE, 625);
ObjectSet("C5L7_T", OBJPROP_YDISTANCE, 122);

ObjectCreate("C5L8", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C5L8", OBJPROP_XDISTANCE, 701);
ObjectSet("C5L8", OBJPROP_YDISTANCE, 120);
ObjectSet("C5L8", OBJPROP_XSIZE, 100);
ObjectSet("C5L8", OBJPROP_YSIZE, 20);
ObjectSet("C5L8", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C5L8","",10,NULL, clrNONE);

ObjectCreate("C5L8_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C5L8_T","0.00 "+AccountCurrency(), 8,"Tahoma", clrWhite);
ObjectSet("C5L8_T", OBJPROP_XDISTANCE, 725);
ObjectSet("C5L8_T", OBJPROP_YDISTANCE, 122);

//+----------------------------------------------------------------------------------------------------------------------- End Symbol 3
ObjectCreate("C6L1", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C6L1", OBJPROP_XDISTANCE, 1);
ObjectSet("C6L1", OBJPROP_YDISTANCE, 140);
ObjectSet("C6L1", OBJPROP_XSIZE, 100);
ObjectSet("C6L1", OBJPROP_YSIZE, 20);
ObjectSet("C6L1", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C6L1","",10,NULL, clrNONE);

ObjectCreate("C6L1_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C6L1_T","Symbol2", 8,"Tahoma", clrWhite);
ObjectSet("C6L1_T", OBJPROP_XDISTANCE, 20);
ObjectSet("C6L1_T", OBJPROP_YDISTANCE, 142);

ObjectCreate("C6L2", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C6L2", OBJPROP_XDISTANCE, 101);
ObjectSet("C6L2", OBJPROP_YDISTANCE, 140);
ObjectSet("C6L2", OBJPROP_XSIZE, 100);
ObjectSet("C6L2", OBJPROP_YSIZE, 20);
ObjectSet("C6L2", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C6L2","",10,NULL, clrNONE);

ObjectCreate("C6L2_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C6L2_T","15 Pionts", 8,"Tahoma", clrWhite);
ObjectSet("C6L2_T", OBJPROP_XDISTANCE, 117);
ObjectSet("C6L2_T", OBJPROP_YDISTANCE, 142);

ObjectCreate("C6L3", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C6L3", OBJPROP_XDISTANCE, 201);
ObjectSet("C6L3", OBJPROP_YDISTANCE, 140);
ObjectSet("C6L3", OBJPROP_XSIZE, 100);
ObjectSet("C6L3", OBJPROP_YSIZE, 20);
ObjectSet("C6L3", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C6L3","",10,NULL, clrNONE);

ObjectCreate("C6L3_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C6L3_T","15  Pionts", 8,"Tahoma", clrWhite);
ObjectSet("C6L3_T", OBJPROP_XDISTANCE, 217);
ObjectSet("C6L3_T", OBJPROP_YDISTANCE, 142);

ObjectCreate("C6L4", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C6L4", OBJPROP_XDISTANCE, 301);
ObjectSet("C6L4", OBJPROP_YDISTANCE, 140);
ObjectSet("C6L4", OBJPROP_XSIZE, 100);
ObjectSet("C6L4", OBJPROP_YSIZE, 20);
ObjectSet("C6L4", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C6L4","",10,NULL, clrNONE);

ObjectCreate("C6L4_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C6L4_T","1  Posistions", 8,"Tahoma", clrWhite);
ObjectSet("C6L4_T", OBJPROP_XDISTANCE, 325);
ObjectSet("C6L4_T", OBJPROP_YDISTANCE, 142);

ObjectCreate("C6L5", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C6L5", OBJPROP_XDISTANCE, 401);
ObjectSet("C6L5", OBJPROP_YDISTANCE, 140);
ObjectSet("C6L5", OBJPROP_XSIZE, 100);
ObjectSet("C6L5", OBJPROP_YSIZE, 20);
ObjectSet("C6L5", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C6L5","",10,NULL, clrNONE);

ObjectCreate("C6L5_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C6L5_T","0.10  Lots", 8,"Tahoma", clrWhite);
ObjectSet("C6L5_T", OBJPROP_XDISTANCE, 425);
ObjectSet("C6L5_T", OBJPROP_YDISTANCE, 142);

ObjectCreate("C6L6", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C6L6", OBJPROP_XDISTANCE, 501);
ObjectSet("C6L6", OBJPROP_YDISTANCE, 140);
ObjectSet("C6L6", OBJPROP_XSIZE, 100);
ObjectSet("C6L6", OBJPROP_YSIZE, 20);
ObjectSet("C6L6", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C2L6","",10,NULL, clrNONE);

ObjectCreate("C6L6_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C6L6_T","0.00 "+AccountCurrency(), 8,"Tahoma", clrWhite);
ObjectSet("C6L6_T", OBJPROP_XDISTANCE, 525);
ObjectSet("C6L6_T", OBJPROP_YDISTANCE, 142);

ObjectCreate("C6L7", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C6L7", OBJPROP_XDISTANCE, 601);
ObjectSet("C6L7", OBJPROP_YDISTANCE, 140);
ObjectSet("C6L7", OBJPROP_XSIZE, 100);
ObjectSet("C6L7", OBJPROP_YSIZE, 20);
ObjectSet("C6L7", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C2L7","",10,NULL, clrNONE);

ObjectCreate("C6L7_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C6L7_T","0.00 "+AccountCurrency(), 8,"Tahoma", clrWhite);
ObjectSet("C6L7_T", OBJPROP_XDISTANCE, 625);
ObjectSet("C6L7_T", OBJPROP_YDISTANCE, 142);

ObjectCreate("C6L8", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C6L8", OBJPROP_XDISTANCE, 701);
ObjectSet("C6L8", OBJPROP_YDISTANCE, 140);
ObjectSet("C6L8", OBJPROP_XSIZE, 100);
ObjectSet("C6L8", OBJPROP_YSIZE, 20);
ObjectSet("C6L8", OBJPROP_BGCOLOR,clrGray);
ObjectSetText("C6L8","",10,NULL, clrNONE);

ObjectCreate("C6L8_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C6L8_T","0.00 "+AccountCurrency(), 8,"Tahoma", clrWhite);
ObjectSet("C6L8_T", OBJPROP_XDISTANCE, 725);
ObjectSet("C6L8_T", OBJPROP_YDISTANCE, 142);

//+----------------------------------------------------------------------------------------------------------------------- End Symbol 4
ObjectCreate("C7L1", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C7L1", OBJPROP_XDISTANCE, 1);
ObjectSet("C7L1", OBJPROP_YDISTANCE, 160);
ObjectSet("C7L1", OBJPROP_XSIZE, 400);
ObjectSet("C7L1", OBJPROP_YSIZE, 30);
ObjectSet("C7L1", OBJPROP_BGCOLOR,clrDodgerBlue);
ObjectSetText("C7L1","",10,NULL, clrNONE);

ObjectCreate("C7L1_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C7L1_T",AccountCompany()+"   "+AccountNumber(), 10,"Tahoma", clrWhite);
ObjectSet("C7L1_T", OBJPROP_XDISTANCE, 100);
ObjectSet("C7L1_T", OBJPROP_YDISTANCE, 165);

ObjectCreate("C7L2", OBJ_BUTTON, 0, 0, 0);
ObjectSet("C7L2", OBJPROP_XDISTANCE, 401);
ObjectSet("C7L2", OBJPROP_YDISTANCE, 160);
ObjectSet("C7L2", OBJPROP_XSIZE, 400);
ObjectSet("C7L2", OBJPROP_YSIZE, 30);
ObjectSet("C7L2", OBJPROP_BGCOLOR,clrDodgerBlue);
ObjectSetText("C7L2","",10,NULL, clrNONE);

ObjectCreate("C7L2_T", OBJ_LABEL, 0, 0, 0);
ObjectSetText("C7L2_T","EA Profit 0.00 "+AccountCurrency(), 10,"Tahoma", clrWhite);
ObjectSet("C7L2_T", OBJPROP_XDISTANCE, 501);
ObjectSet("C7L2_T", OBJPROP_YDISTANCE, 165);

/*
ObjectCreate("6", OBJ_LABEL, 0, 0, 0);
ObjectSetText("6",StringFormat("curentpofit=%G",AccountEquity()), 10,"Tahoma", clrGreenYellow);
ObjectSet("6", OBJPROP_XDISTANCE, 1);
ObjectSet("6", OBJPROP_YDISTANCE, 120);

*/
 
}

void OnTimer(){
//void OnTick(){


eng();


//Comment("high "+height+"\n width "+width);
   
}
//---------------------------------------------------------------------------------------------------------------------------------------------------------
