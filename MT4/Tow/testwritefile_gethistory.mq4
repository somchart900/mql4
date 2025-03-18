//+------------------------------------------------------------------+
//|                                                     Chartmax.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
 EventSetMillisecondTimer(1000);
 //Comment(TimeHour(TimeLocal()));
  //Comment(TimeHour(TimeLocal())+"."+TimeMinute(TimeLocal()));   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   EventKillTimer();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
//void OnTick()
void OnTimer()
  {
 history_2();
 }
//+------------------------------------------------------------------+
//----------------------------------------------------------------------------------------------------------
void history_2()
  {
   
   bool res;
   double profit=0;
   double volume=0;
   for(int i = 0; i < OrdersHistoryTotal(); i++)
     {
      res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
      if(OrderSymbol()==Symbol())
        {
         //if(OrderMagicNumber()==MagicNumber)
          // {
               volume=OrderLots();
               profit=OrderProfit();              
          // }//--end magi
        }//--end symb
     } //--end for
   if(profit<0)
     {
      if(volume>=0.02)
        {
        string Sym1=StringSubstr(Symbol(),0,6)+".txt";
             if(!FileIsExist(Sym1))
                {
                 int filehandle = FileOpen( Sym1,FILE_WRITE|FILE_TXT);
                 FileWriteString(filehandle,"teste");  
                 FileClose(filehandle); 
                 }
        }
     }else
         {
          string Sym1=StringSubstr(Symbol(),0,6)+".txt";
          if(FileIsExist(Sym1))
            {
            FileDelete(Sym1);
            }
         }
         Comment(volume+" "+profit);
  }
//-----------------------------