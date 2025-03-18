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
extern double Lots =0.01;
extern double TP= 160;
extern double SL= 150;
extern double LotsXponent =2;
double Start_Lots =Lots;
extern int MagicNumber =1112021;
extern int Slippage =5;
input string Parbolic = " ----- Parbolic SAR Setting -----";
input ENUM_TIMEFRAMES TIMEFRAME =PERIOD_M5;
extern double Parbolic_Step =0.02;
extern double Parbolic_Maximum =0.2;
input string MovingAverage = " ----- MovingAverage Setting -----";
input ENUM_MA_METHOD MA_MATHOD=MODE_EMA;
input ENUM_APPLIED_PRICE APPLIED_PRICE=PRICE_CLOSE;
input int MA_piriod=60;
input int Allow_Spread=15;
input double loss1=0.02;
input double loss2=0.04;
input double loss3=0.08;
bool Check_B,Check_S;
input string StartTredingTime="00:01";
input string StopTredingTime="23:59";
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
void OpenBuy()
  {
   history_buy();
   int ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,NULL,MagicNumber,0,clrGreen);
   TPSL();
  }
//+------------------------------------------------------------------+
void OpenSell()
  {
   history_sell();
   int ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,0,NULL,MagicNumber,0,clrRed);
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
double MA;
double SAR0;
double SAR1;
int spread;
void GetIndy()
  {
   SAR1=iSAR(Symbol(),TIMEFRAME,Parbolic_Step,Parbolic_Maximum,1);
   SAR0=iSAR(Symbol(),TIMEFRAME,Parbolic_Step,Parbolic_Maximum,0);
   MA=iMA(Symbol(),TIMEFRAME,MA_piriod,0,MA_MATHOD,APPLIED_PRICE,0);
   spread = (int)MarketInfo(Symbol(),MODE_SPREAD); 
  }
//--------------------------------------------------------------------------------------------------
void Treding()
  {
   GetIndy();
   GetStat();
   double open1=iOpen(Symbol(),TIMEFRAME,1);
   if(BuyOpen==0)
      {
       if(Check_B==false)
       {
          history_Check_B();
          Check_B=true;
        }
      if(SAR1 > open1)
        {
         if(SAR0 < open1)
           {
            if(SAR1 > MA)
               {
                if(spread<=Allow_Spread)
                  {
                   OpenBuy();
                   }
               } 
           }
        }
      }else{
      Check_B=false;
      }
//-------------------
   if(SellOpen==0)
      {
      if(Check_S==false)
         {
         history_Check_S();
         Check_S=true;
         }
      if(SAR1 < open1)
        {
         if(SAR0 > open1)
           {
            if(SAR1 < MA)
               {
                if(spread<=Allow_Spread)
                  {
                   OpenSell();
                  }
               } 
           }
        }
      }else{
      Check_S=false;
      }
//-------------------


  }
//----------------------------------------------------------------------------------------------------------
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
      if(volume==loss1)
        {
        string Sym1=StringSubstr(Symbol(),0,6)+"2b.txt";
            if(!FileIsExist(Sym1))
                {
                 int filehandle = FileOpen( Sym1,FILE_WRITE|FILE_TXT);
                 FileWriteString(filehandle,"teste");  
                 FileClose(filehandle); 
                 }
        }
      if(volume==loss2)
        {
        string Sym2=StringSubstr(Symbol(),0,6)+"3b.txt";
            if(!FileIsExist(Sym2))
                {
                 int filehandle = FileOpen( Sym2,FILE_WRITE|FILE_TXT);
                 FileWriteString(filehandle,"teste");  
                 FileClose(filehandle); 
                 }
        }
      if(volume==loss3)
        {
        string Sym3=StringSubstr(Symbol(),0,6)+"4b.txt";
            if(!FileIsExist(Sym3))
                {
                 int filehandle = FileOpen( Sym3,FILE_WRITE|FILE_TXT);
                 FileWriteString(filehandle,"teste");  
                 FileClose(filehandle); 
                 }
        }
     }else
         {
          string Sym1=StringSubstr(Symbol(),0,6)+"2b.txt";
          if(FileIsExist(Sym1))
            {
            FileDelete(Sym1);
            }
          string Sym2=StringSubstr(Symbol(),0,6)+"3b.txt";
          if(FileIsExist(Sym2))
            {
            FileDelete(Sym2);
            }
          string Sym3=StringSubstr(Symbol(),0,6)+"4b.txt";
          if(FileIsExist(Sym3))
            {
            FileDelete(Sym3);
            }
            
            
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
      if(volume==loss1)
        {
        string Sym1=StringSubstr(Symbol(),0,6)+"2s.txt";
            if(!FileIsExist(Sym1))
                {
                 int filehandle = FileOpen( Sym1,FILE_WRITE|FILE_TXT);
                 FileWriteString(filehandle,"teste");  
                 FileClose(filehandle); 
                 }
        }
      if(volume==loss2)
        {
        string Sym2=StringSubstr(Symbol(),0,6)+"3s.txt";
            if(!FileIsExist(Sym2))
                {
                 int filehandle = FileOpen( Sym2,FILE_WRITE|FILE_TXT);
                 FileWriteString(filehandle,"teste");  
                 FileClose(filehandle); 
                 }
        }
      if(volume==loss3)
        {
        string Sym3=StringSubstr(Symbol(),0,6)+"4s.txt";
            if(!FileIsExist(Sym3))
                {
                 int filehandle = FileOpen( Sym3,FILE_WRITE|FILE_TXT);
                 FileWriteString(filehandle,"teste");  
                 FileClose(filehandle); 
                 }
        }
     }else
         {
          string Sym1=StringSubstr(Symbol(),0,6)+"2s.txt";
          if(FileIsExist(Sym1))
            {
            FileDelete(Sym1);
            }
          string Sym2=StringSubstr(Symbol(),0,6)+"3s.txt";
          if(FileIsExist(Sym2))
            {
            FileDelete(Sym2);
            }
          string Sym3=StringSubstr(Symbol(),0,6)+"4s.txt";
          if(FileIsExist(Sym3))
            {
            FileDelete(Sym3);
            }
            
            
         }
  }//end func
//-----------------------------
//+------------------------------------------------------------------+
void OnTick()
  {
    datetime time=TimeLocal();
    string now=TimeToStr(time,TIME_MINUTES);

    if(now >= StartTredingTime && now <= StopTredingTime){
    //Comment("EA START");
     Treding();
     }else
     {
    // Comment("EA_SLEEP");
     }
  }
//----------------------------------------------------------------------------------------------------------

//+------------------------------------------------------------------+
