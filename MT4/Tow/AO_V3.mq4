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
extern double Lots =0.1;
double Start_Lots=Lots;
extern double LotsXponent =2;
extern double TP=800;
extern int TP1 =250;
extern double SL=500;
extern bool Enable_TrailingStop =True;
extern int TralingStart_After_Profit =300;
extern int TralingStep =200;
extern bool  Enable_ProfitLock =False;
extern int Lock_After_Profit =150;
extern int Lock_Profit =10;


extern int MagicNumber =9062020;
extern int Slippage =5;
input int Allow_Spread=25;
input ENUM_TIMEFRAMES TIMEFRAME =PERIOD_H1;
bool minitp=True;

enum ENUM_RISK  
   { 
    hardcore, 
    midium,  
    normal 
   };
input ENUM_RISK RISK=hardcore;

//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
void OpenBuy()
  {
   history();
   int ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,DoubleToStr(max,2),MagicNumber,0,clrNONE);
   minitp=True;
   TPSL();  
  }
//-----------------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OpenSell()
  {
   history();
   int ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,0,DoubleToStr(max,2),MagicNumber,0,clrNONE);
   minitp=True;
   TPSL();
  }
//-----------------------------

//--------------------------------------------------------------------------------------------------
void  CloseSell()
  {
   bool res;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      res = OrderSelect(i,SELECT_BY_POS);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL)
        {
         res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);
        }

     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  CloseBuy()
  {
   bool res;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      res = OrderSelect(i,SELECT_BY_POS);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY)
        {
         res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);
        }
     }
  }

//-----------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
void  CloseSellTP1()
  {
   bool res;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      res = OrderSelect(i,SELECT_BY_POS);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL)
        {
         res = OrderClose(OrderTicket(),OrderLots()/2,OrderClosePrice(),Slippage,clrNONE);
        }

     }
   minitp=False;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  CloseBuyTP1()
  {
   bool res;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      res = OrderSelect(i,SELECT_BY_POS);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY)
        {
         res = OrderClose(OrderTicket(),OrderLots()/2,OrderClosePrice(),Slippage,clrNONE);
        }
     }
   minitp=False;
  }

//-----------------------------------------------------------------------------------------------------

//-----------------------------
int BuyOpen;
int SellOpen;
double BuyOpenProfit;
double SellOpenProfit;
void GetStat()
  {
   BuyOpen=0;
   SellOpen=0;
   SellOpenProfit=0;
   BuyOpenProfit=0;
   bool res;
   for(int i = 0; i < OrdersTotal(); i++)
     {
      res = OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY)
        {
         BuyOpen++;
         BuyOpenProfit+=OrderProfit()+OrderSwap()+OrderCommission();
        }
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL)
        {
         SellOpen++;
         SellOpenProfit+=OrderProfit()+OrderSwap()+OrderCommission();
        }
     }

  }
//-----------------------------
//----------------------------------------------------------------------------------------------------------
void TrailingStop()
  {
   bool res;
   double stoploss;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber() == MagicNumber)
           {
            if(OrderType() == OP_BUY)
              {
               if(Bid-OrderOpenPrice() > TralingStart_After_Profit*Point)
                 {
                  if(OrderStopLoss() < Bid-TralingStep*Point)
                    {
                     res = OrderModify(OrderTicket(),OrderOpenPrice(),Bid-TralingStep*Point,OrderTakeProfit(),0,0);
                    }
                 }

              }
            if(OrderType() == OP_SELL)
              {
               if(OrderStopLoss()==0)
                 {
                  stoploss=100000;
                 }
               else
                 {
                  stoploss=OrderStopLoss();
                 }
               if(OrderOpenPrice()-Ask > TralingStart_After_Profit*Point)
                 {
                  if(stoploss > Ask+TralingStep*Point)
                    {
                     res = OrderModify(OrderTicket(),OrderOpenPrice(),Ask+TralingStep*Point,OrderTakeProfit(),0,0);
                    }
                 }
              }

           }
        }
     }
  }

//-----------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
void ProfitLock()
  {
   bool res;
   double stoploss;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber() == MagicNumber)
           {
            if(OrderType() == OP_BUY)
              {
               if(Bid-OrderOpenPrice() > Lock_After_Profit*Point)
                 {
                  if(OrderStopLoss() < OrderOpenPrice()+Lock_Profit*Point)
                    {
                     res = OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+Lock_Profit*Point,OrderTakeProfit(),0,0);
                    }
                 }

              }
            if(OrderType() == OP_SELL)
              {
               if(OrderStopLoss()==0)
                 {
                  stoploss=100000;
                 }
               else
                 {
                  stoploss=OrderStopLoss();
                 }
               if(OrderOpenPrice()-Ask > Lock_After_Profit*Point)
                 {
                  if(stoploss > OrderOpenPrice()-Lock_Profit*Point)
                    {
                     res = OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-Lock_Profit*Point,OrderTakeProfit(),0,0);
                    }
                 }
              }

           }
        }
     }
  }

//-----------------------------------------------------------------------------------------------------------------------------


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TP_1()
  {

   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber() == MagicNumber)
           {
            if(OrderType() == OP_BUY)
              {
               if(Bid-OrderOpenPrice() > TP1*Point)
                 {
                  if(minitp)
                    {
                     CloseBuyTP1();
                    }
                 }

              }
            if(OrderType() == OP_SELL)
              {
               if(OrderOpenPrice()-Ask > TP1*Point)
                 {
                  if(minitp)
                    {
                     CloseSellTP1();
                    }
                 }

              }

           }
        }
     }
  }

//-----------------------------------------------------------------------------------------------------------------------------

//--------------------------------------------
void Treding()
  {
   int vspread = (int)MarketInfo(Symbol(),MODE_SPREAD);
   double AO=iAO(Symbol(),TIMEFRAME,1);
   GetStat();
   if(AO >0)
     {
      CloseSell();
      Comment("FOCUS BUY \n","BUY OPEN  "+IntegerToString(BuyOpen)+"\nMax "+DoubleToStr(max,2)+"\ncurrent "+DoubleToStr(current,2)+"\nprofit "+DoubleToStr(BuyOpenProfit,2));
      if(BuyOpen==0 && Open[3] > Close[3] && Open[2] > Close[2] && Close[1] >Open[1]&& Close[1] < High[3])
        {
         OpenBuy();
        }
     }
   if(AO <0)
     {
      CloseBuy();
      Comment("FOCUS SELL \n","SELL OPEN  "+IntegerToString(SellOpen)+"\nMax "+DoubleToStr(max,2)+"\ncurrent "+DoubleToStr(current,2)+"\nprofit "+DoubleToStr(SellOpenProfit,2));
      if(SellOpen==0 && Open[3] < Close[3] && Open[2] < Close[2] && Close[1] <Open[1]&& Close[1] > Low[3])
        {
         OpenSell();
        }
     }
  }

//+------------------------------------------------------------------+
//-----------------------------------------------------------------------------------------------------------------------------
double max;
double current;
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
void history()
  {
   
   Lots=Start_Lots;
   bool res;
   double profit=0;
   double lots=0;
   max=0;
   current=0;
   for(int i = 0; i < OrdersHistoryTotal(); i++)
     {
      res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
        {
         lots=OrderLots();
         max=StrToDouble(OrderComment());
         current+=OrderProfit()+OrderSwap()+OrderCommission();
         profit=OrderProfit();
        }
     } //--end for
   if(profit<0)
     {
      if(lots>=Start_Lots)
        {
          Lots =lots*LotsXponent;
        }
       else
         {
          Lots =Start_Lots*LotsXponent;
         }
     }
   if(profit >= 0)
     {
      if(max>current)
        {
         if(RISK==hardcore)
            {
              if(lots>=Start_Lots)
                 {
                   Lots =lots;
                 }
               else
                 {
                  Lots =Start_Lots*LotsXponent;
                 } 
            }  
         if(RISK==midium)
            {
              Lots=Start_Lots*LotsXponent;
            }  

        }
     }
   if(current>max)
     {
      max=current;
     }
  }
//-----------------------------

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
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
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

//-----------------------------------------------------------------------------------------------------------------------------


//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   Treding();
   TP_1();
   if(Enable_TrailingStop)
      TrailingStop();
   if(Enable_ProfitLock)
      ProfitLock();
  }
//----------------------------------------------------------------------------------------------------------

//+------------------------------------------------------------------+
