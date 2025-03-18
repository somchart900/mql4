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
  // ObjectsDeleteAll();
   ChartSetInteger(ChartID(),CHART_SHOW_PERIOD_SEP,0,0);
   ChartSetInteger(ChartID(),CHART_FOREGROUND,0,0);
   ChartSetInteger(ChartID(),CHART_SHOW_GRID,0,0);
   ChartSetInteger(ChartID(),CHART_SHIFT,0,1);
   ChartSetInteger(ChartID(),CHART_AUTOSCROLL,0,1);
   ChartSetInteger(ChartID(),CHART_MODE,CHART_CANDLES,1);
   ChartSetInteger(ChartID(),CHART_COLOR_CANDLE_BEAR,clrRed);
   ChartSetInteger(ChartID(),CHART_COLOR_CANDLE_BULL,clrLime);
   ChartSetInteger(ChartID(),CHART_COLOR_CHART_DOWN,clrRed);
   Check_B=false;
   Check_S=false;
   Check_BF=false;
   Check_SF=false;
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
extern double TP= 155;
extern double SL= 150;
extern double LotsXponent =2;
double Start_Lots =Lots;
extern int MagicNumber =20210322;
extern int Slippage =5;
input string Parbolic = " ----- Parbolic SAR Setting -----";
input ENUM_TIMEFRAMES TIMEFRAME =PERIOD_M5;
extern double Parbolic_Step =0.02;
extern double Parbolic_Maximum =0.2;
input int Allow_Spread=10;
bool Check_B,Check_S;
bool Check_BF,Check_SF;
input string BuyStart="2b.txt";
input string SellStart="2s.txt";
input string StartTredingTime="00:01";
input string StopTredingTime="23:59";
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
void OpenBuy()
  {
   history_buy();
   int ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,"SAR_TRUE",MagicNumber,0,clrGreen);
   TPSL();
  }
//+------------------------------------------------------------------+
void OpenSell()
  {
   history_sell();
   int ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,0,"SAR_TRUE",MagicNumber,0,clrRed);
   TPSL();  
  }
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
      res = OrderSelect(i,SELECT_BY_POS);
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
           } //+end magic 
        }//+end symbol
     }//+end for
  }
//-----------------------------
//-----------------------------
double SAR0;
double SAR1;
double open1;
int spread;
void GetIndy()
  {
   SAR1=iSAR(Symbol(),TIMEFRAME,Parbolic_Step,Parbolic_Maximum,1);
   SAR0=iSAR(Symbol(),TIMEFRAME,Parbolic_Step,Parbolic_Maximum,0);
   spread = (int)MarketInfo(Symbol(),MODE_SPREAD); 
   open1=iOpen(Symbol(),TIMEFRAME,1);
  }
//--------------------------------------------------------------------------------------------------
void Treding_Buy()
  {
   if(BuyOpen==0)
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
//-------------------
  }
//----------------------------------------------------------------------------------------------------------

void Treding_Sell()
  {
//-------------------
   if(SellOpen==0)
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
//-------------------
   }
  




//----------------------------------------------------------------------------------------------------------
void TPSL()
  {
   double SL_SET;
   double TP_SET;
   bool res;
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
                   }else
                       {
                       SL_SET=OrderOpenPrice()-SL*Point;
                       }
                 if(TP==0)
                   {
                    TP_SET=0;
                   }else
                       {
                       TP_SET=OrderOpenPrice()+TP*Point;
                      }
                res = OrderModify(OrderTicket(),OrderOpenPrice(),SL_SET,TP_SET,0,0);
               } ///---endtype
              if(OrderType() == OP_SELL)
                {
                 if(SL==0)
                   {
                    SL_SET=0;
                    }else
                        {
                        SL_SET=OrderOpenPrice()+SL*Point;
                        }
                  if(TP==0)
                    {
                     TP_SET=0;
                    }else
                        {
                        TP_SET=OrderOpenPrice()-TP*Point;
                        }
                 res = OrderModify(OrderTicket(),OrderOpenPrice(),SL_SET,TP_SET,0,0);
                }///---endtype
              }//++end magic 
           }  //++end symbol
        }  //++end select
     }//++end for 
  }//++end func
//-----------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
void history_buy()
  {
   Lots=Start_Lots;
   bool res;
   double profit=0;
   double lots=0;
   for(int i = 0; i < OrdersHistoryTotal(); i++)
     {
      res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
      if(OrderSymbol()==Symbol())
        {
         if(OrderMagicNumber()==MagicNumber)
           {
            if(OrderType()==OP_BUY)
              {
               lots=OrderLots();
               profit=OrderProfit();
              }
           }
        }
     } //--end for
   if(profit<0)
     {
      Lots =NormalizeDouble(lots*LotsXponent,2);
     }

  }
//-----------------------------
//----------------------------------------------------------------------------------------------------------
void history_sell()
  {
   Lots=Start_Lots;
   bool res;
   double profit=0;
   double lots=0;
   for(int i = 0; i < OrdersHistoryTotal(); i++)
     {
      res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
      if(OrderSymbol()==Symbol())
        {
         if(OrderMagicNumber()==MagicNumber)
            {
            if(OrderType()==OP_SELL)
              {
               lots=OrderLots();
               profit=OrderProfit();
              }
            }
        }
     } //--end for
   if(profit<0)
     {
      Lots =NormalizeDouble(lots*LotsXponent,2);
     }

  }
//-----------------------------
//----------------------------------------------------------------------------------------------------------
void history_Check_B()
  {
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
            if(OrderType()==OP_BUY)
               {
                volume=OrderLots();
                profit=OrderProfit();
                }              
           }//--end magi
        }//--end symb
     } //--end for
   if(profit<0)
     { 
     Check_B=true;
     }else
         {
          Check_B=false;
         }
 
       string Sym1=StringSubstr(Symbol(),0,6)+""+BuyStart;
      if(FileIsExist(Sym1))
         {
          Check_BF=true;
         }else
             {
              Check_BF=false;
             } 
 
  }//end func
//-----------------------------
//----------------------------------------------------------------------------------------------------------
void history_Check_S()
  {
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
            if(OrderType()==OP_SELL)
               {
                volume=OrderLots();
                profit=OrderProfit();
                }              
           }//--end magi
        }//--end symb
     } //--end for
   if(profit<0)
     { 
      Check_S=true;
     }else
         {
          Check_S=false;
         }
  
      string Sym1=StringSubstr(Symbol(),0,6)+""+SellStart;
      if(FileIsExist(Sym1))
         {
          Check_SF=true;
         }else
             {
              Check_SF=false;
             }   
  }//end func
//-----------------------------
//+------------------------------------------------------------------+
void OnTick()
  {
    GetIndy();
    GetStat();
    if(BuyOpen==0)
       {
       history_Check_B();
       }
    if(SellOpen==0)
       {
       history_Check_S();
       }
    datetime time=TimeLocal();
    string now=TimeToStr(time,TIME_MINUTES);

    if(now >= StartTredingTime && now <= StopTredingTime){
    Comment("EA START");
       if(Check_B==true || Check_BF==true)
          {
          Treding_Buy();
          }
       if(Check_S==true || Check_SF==true)
          {
          Treding_Sell();
          }
     }else
     {
      Comment("EA_SLEEP");
     }
  }
//----------------------------------------------------------------------------------------------------------

//+------------------------------------------------------------------+
