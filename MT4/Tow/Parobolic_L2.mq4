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
extern double Lots =0.05;
extern double TP= 75;
extern double SL= 150;
extern double LotsXponent =3;
double Start_Lots =Lots;
extern int MagicNumber =210420;
extern int Slippage =10;
input ENUM_TIMEFRAMES TIMEFRAME =PERIOD_M1; 
extern double Parbolic_Step =0.02;
extern double Parbolic_Maximum =0.2;
input int Allow_Spred=31;
int ticket,BuyOpen,SellOpen,lastbar;
double spd;
string Sym,file,Sym1,file1,sfdb,sfds;

//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
void OpenBuy(){ 
     Lots=Start_Lots;
     bool res;
     double pfb=0;
     double LL=0;
     for(int i = 0;i < OrdersHistoryTotal();i++){ 
           res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY ){ pfb=OrderProfit(); LL=OrderLots();}                  
      }  
                if(pfb<0){ Lots =LL*LotsXponent;       
                 ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,Ask-SL*Point,Ask+TP*Point,"Parabolic",MagicNumber,0,clrNONE);
                 lastbar=Bars; 
                }         
}   
 //-----------------------------
 //----------------------------------------------------------------------------------------------------- 

void OpenSell(){ 
Lots=Start_Lots;
 bool res;
 double pfs=0;
 double LL=0;
     for(int i = 0;i < OrdersHistoryTotal();i++){  
           res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL){ pfs=OrderProfit(); LL=OrderLots();}                      
      } 
               if(pfs<0){ Lots =LL*LotsXponent;
                      ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,Bid+SL*Point,Bid-TP*Point,"Parabolic",MagicNumber,0,clrNONE); 
                      lastbar=Bars;                     
               }  
}   
 //-----------------------------
 //-------------------------------------------------------------------------------------------------- 

 void GetStat(){SellOpen=0; BuyOpen=0;
 bool res;
     for(int i = 0;i < OrdersTotal();i++){  
     res = OrderSelect(i,SELECT_BY_POS);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL){SellOpen++;}
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY){BuyOpen++;} 
      }   
}   
 //-----------------------------

double SAR1,SAR0;
void GetIndy(){ 
  SAR1=iSAR(Symbol(),TIMEFRAME,Parbolic_Step,Parbolic_Maximum,1);
  SAR0=iSAR(Symbol(),TIMEFRAME,Parbolic_Step,Parbolic_Maximum,0); 
     spd = Ask-Bid;
     spd=MathRound(spd/Point);
}
//--------------------------------------------------------------------------------------------------  
void Treding(){ GetIndy();  GetStat();
sfdb=StringSubstr(Symbol(),0,6)+"_BP";
sfds=StringSubstr(Symbol(),0,6)+"_SP";
if(BuyOpen==1){ BUY_TP();}
if(SellOpen==1){ SELL_TP();}

      if(SAR1 < Open[1] && SAR0 > Open[1]){
                   if(lastbar!=Bars){
                              if(SellOpen==0){ if(spd <= Allow_Spred){ OpenSell();}}                  
                   }                   
     }
     if(SAR1 > Open[1] && SAR0 < Open[1] ){
                   if(lastbar!=Bars){
                             if(BuyOpen==0){if(spd <= Allow_Spred){OpenBuy();}}
                   }         
     }
                    if(FileIsExist(sfds)){Lots=Start_Lots;
                       if(SellOpen==0){
                          ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,Bid+SL*Point,Bid-TP*Point,"Parabolic",MagicNumber,0,clrNONE); 
                          lastbar=Bars;
                        }
                     FileDelete(sfds);
                    } 
                    if(FileIsExist(sfdb)){Lots=Start_Lots;
                       if(BuyOpen==0){
                           ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,Ask-SL*Point,Ask+TP*Point,"Parabolic",MagicNumber,0,clrNONE);
                           lastbar=Bars;
                           }
                     FileDelete(sfdb);
                    }
}
//----------------------------------------------------------------------------------------------------------  


void BUY_TP(){ bool res;
  for(int i=OrdersTotal()-1;i>=0;i--){
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
          if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber ){
                 if(OrderType() == OP_BUY){ double TPB =OrderOpenPrice()+TP*Point; TPB=NormalizeDouble(TPB,Digits);
                    if(OrderTakeProfit() != TPB){                                      
                          res = OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-SL*Point,OrderOpenPrice()+TP*Point,0,0);                         
                     }
                 }           
          }                                    
      }       
   } 
}

//----------------------------------------------------------------------------------------------------------------------------- 

//----------------------------------------------------------------------------------------------------------  
void SELL_TP(){ bool res;
  for(int i=OrdersTotal()-1;i>=0;i--){
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
          if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber ){
                 if(OrderType() == OP_SELL){ double TPS =OrderOpenPrice()-TP*Point; TPS=NormalizeDouble(TPS,Digits);
                    if(OrderTakeProfit() != TPS){                                      
                          res = OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+SL*Point,OrderOpenPrice()-TP*Point,0,0);                         
                     }
                 }           
          }                                    
      }       
   } 
}



void OnTick(){ 
Treding();

}
//----------------------------------------------------------------------------------------------------------

