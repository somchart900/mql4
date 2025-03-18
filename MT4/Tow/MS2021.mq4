//+------------------------------------------------------------------+
//|                                                    .mq4 |
//|                         |
//|                                          |
//+------------------------------------------------------------------+
#property copyright "2021"
#property link      "https://www.facebook.com/huaylungcafe"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//ObjectsDeleteAll();
   ChartSetInteger(ChartID(),CHART_SHOW_PERIOD_SEP,0,0);
   ChartSetInteger(ChartID(),CHART_FOREGROUND,0,0);
   ChartSetInteger(ChartID(),CHART_SHOW_GRID,0,0);
   ChartSetInteger(ChartID(),CHART_SHIFT,0,1);
   ChartSetInteger(ChartID(),CHART_AUTOSCROLL,0,1);
   ChartSetInteger(ChartID(),CHART_MODE,CHART_CANDLES,1);
   ChartSetInteger(ChartID(),CHART_COLOR_CANDLE_BEAR,clrRed);
   ChartSetInteger(ChartID(),CHART_COLOR_CANDLE_BULL,clrLime);
   ChartSetInteger(ChartID(),CHART_COLOR_CHART_DOWN,clrRed);
   work_1=false;
   work_2=false;
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
extern double Lots =0.10;
extern int TP= 150;
extern int SL= 150;
extern double LotsXponent =2;
double Start_Lots =Lots;
extern int MagicNumber =20211;
extern int Slippage =5;
input string Parbolic = " ----- Parbolic SAR Setting -----";
input ENUM_TIMEFRAMES TIMEFRAME =PERIOD_M5;
extern double Parbolic_Step =0.02;
extern double Parbolic_Maximum =0.2;
input string MACD = " -----   MACD Setting     -----";
input ENUM_APPLIED_PRICE Apply_to=PRICE_CLOSE;
input int Fast_EMA=12;
input int Slow_EMA=26;
input int MACD_SMA=9;
input ENUM_TIMEFRAMES TIMEFRAME_MACD =PERIOD_M30;
input int Allow_Spread=10;
input string Working_1 = " -----   Working_1     -----"; 
input string StartTredingTime_1="12:01";
input string StopTredingTime_1="15:30";
input string Working_2 = " -----   Working_2     -----";
input string StartTredingTime_2="19:01";
input string StopTredingTime_2="23:00";
bool work_1,work_2;
//----------------------------------------------------------------------------------------------------------
void OpenBuy()
  {
   history();
   int ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,NULL,MagicNumber,0,clrBlueViolet);
   TPSL();
  }
//-----------------------------
//-----------------------------------------------------------------------------------------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OpenSell()
  {
   history();
   int ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,0,NULL,MagicNumber,0,clrYellow);
   TPSL();
  }
//-----------------------------
//-----------------------------
int BuyOpen;
int SellOpen;
//-----------------------------
void GetStat()
  {
   BuyOpen=0;
   SellOpen=0;
   bool res;
   for(int i = 0; i < OrdersTotal(); i++)
     {
      res = OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol())
        {
         if(OrderMagicNumber()==MagicNumber)
           {
            if(OrderType()==OP_BUY)
              {
               BuyOpen++;
              }
            if(OrderType()==OP_SELL)
              {
               SellOpen++;
              }
           }//--MagicNumber

        }//--symbol

     }//+end for

  }


//-----------------------------
double TREND;
double SAR0;
double SAR1;
double open1;
int spread;
//int bars;
void GetIndy()
  {
   SAR1=iSAR(Symbol(),TIMEFRAME,Parbolic_Step,Parbolic_Maximum,1);
   SAR0=iSAR(Symbol(),TIMEFRAME,Parbolic_Step,Parbolic_Maximum,0);
   TREND=iMACD(Symbol(),TIMEFRAME_MACD,Fast_EMA,Slow_EMA,MACD_SMA,Apply_to,MODE_MAIN,1);
   spread = (int)MarketInfo(Symbol(),MODE_SPREAD);
   open1=iOpen(Symbol(),TIMEFRAME,1);
   
  }
  //--------------------------------------------------------------------------------------------------
void Treding()
  {
   
   GetStat();
   if(BuyOpen==0&&SellOpen==0)
     { 
       GetIndy();
      if(TREND>0)
         {
          if(SAR1 > open1)
            {
            if(SAR0 < open1)
              {
              if(spread<=Allow_Spread)
                {
                 OpenBuy();
                }
              }
            }
         }
//---------------------------
      if(TREND<0)
         {
          if(SAR1 < open1)
            {
            if(SAR0 > open1)
              {
              if(spread<=Allow_Spread)
                {
                 OpenSell();
                }
              }
            }
         }     
      
     }else{
            
           } //+----BuyOpen==0&&SellOpen==0
  }//+----------end treading
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
void TPSL()
  {
   double SL_SET;
   double TP_SET;
   bool res;
   //for(int i = 0; i < OrdersHistoryTotal(); i++)
      for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol())
           {
            if(OrderMagicNumber()==MagicNumber)
              {
               if(OrderType() == OP_BUY)
                 {
                  if(SL==0)
                    {
                     SL_SET=0;
                    }
                  else
                    {
                     SL_SET=OrderOpenPrice()-SL*Point;
                    }
                  if(TP==0)
                    {
                     TP_SET=0;
                    }
                  else
                    {
                     TP_SET=OrderOpenPrice()+TP*Point;
                    }
                  res = OrderModify(OrderTicket(),OrderOpenPrice(),SL_SET,TP_SET,0,0);
                 }
               if(OrderType() == OP_SELL)
                 {
                  if(SL==0)
                    {
                     SL_SET=0;
                    }
                  else
                    {
                     SL_SET=OrderOpenPrice()+SL*Point;
                    }
                  if(TP==0)
                    {
                     TP_SET=0;
                    }
                  else
                    {
                     TP_SET=OrderOpenPrice()-TP*Point;
                    }
                  res = OrderModify(OrderTicket(),OrderOpenPrice(),SL_SET,TP_SET,0,0);
                 }
              }
           }
        }
     }
  }

//-----------------------------------------------------------------------------------------------------------------------------


//----------------------------------------------------------------------------------------------------------
void history()
  {
   Lots=Start_Lots;
   bool res;
   double profit=0;
   double volume=0;
   for(int i = 0; i < OrdersHistoryTotal(); i++)
     {
      res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
      if(OrderSymbol()==Symbol())
        {
         if(OrderMagicNumber()==MagicNumber)
           {
               volume=OrderLots();
               profit=OrderProfit();              
           }//--end magi
        }//--end symb
     } //--end for
   if(profit<0)
     {
      Lots =NormalizeDouble(volume*LotsXponent,2);
     }
  }
//-----------------------------
//+------------------------------------------------------------------+
void OnTick()
  {  
    datetime time=TimeLocal();
    string now=TimeToStr(time,TIME_MINUTES);
    if(now >= StartTredingTime_1 && now <= StopTredingTime_1){
      work_1=true;
     }else
     {
      work_1=false;
     }
    if(now >= StartTredingTime_2 && now <= StopTredingTime_2){
      work_2=true;
     }else
     {
      work_2=false;
     }
    if(work_1==true || work_2==true)
     {
      Treding();
      Comment("EA Start");
     }else
     {
      Comment("EA Stop");
     }
  }
//----------------------------------------------------------------------------------------------------------


//+------------------------------------------------------------------+
