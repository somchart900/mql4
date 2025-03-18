//+------------------------------------------------------------------+
//|                                                    .mq4 |
//|                         |
//|                                          |
//+------------------------------------------------------------------+
#property copyright "."
#property link      "https://www.facebook.com/huaylungcafe"
#property version   "1.00"
#property strict
#import "shell32.dll"
int ShellExecuteW(int hwnd,string Operation,string File,string Parameters,string Directory,int ShowCmd);
#import 
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
extern double Lots =0.01;
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
string Sym,Sym1,buy2,buy3,buy4,buy5,sell2,sell3,sell4,sell5;
bool SINGB=True;
bool SINGS=True;
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
                if(pfb<0){ Lots =LL*LotsXponent;}       
                 ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,Ask-SL*Point,Ask+TP*Point,"Parabolic",MagicNumber,0,clrNONE);
                 lastbar=Bars;   
       
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
               if(pfs<0){ Lots =LL*LotsXponent;}
                      ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,Bid+SL*Point,Bid-TP*Point,"Parabolic",MagicNumber,0,clrNONE); 
                      lastbar=Bars;                     
                 
}   
 //-----------------------------
 //-------------------------------------------------------------------------------------------------- 

 //----------------------------------------------------------------------------------------------------- 


 //-----------------------------
 void GetStat(){ 
Sym1=StringSubstr(Symbol(),0,6)+"_BP.bat";
buy2="c:\\2\\"+Sym1; 
buy3="c:\\3\\"+Sym1; 
buy4="c:\\4\\"+Sym1; 
buy5="c:\\5\\"+Sym1; 
Sym=StringSubstr(Symbol(),0,6)+"_SP.bat";
sell2="c:\\2\\"+Sym; 
sell3="c:\\3\\"+Sym; 
sell4="c:\\4\\"+Sym; 
sell5="c:\\5\\"+Sym; 
 SellOpen=0; 
 BuyOpen=0; 
 bool res;
     for(int i = 0;i < OrdersTotal();i++){  
     res = OrderSelect(i,SELECT_BY_POS);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY){BuyOpen++;
              if(OrderLots() == 0.03){
                    if(SINGB){ShellExecuteW(NULL,"open",buy2,NULL,NULL,1); SINGB=False;}
              }
               if(OrderLots() == 0.09){
                    if(SINGB){ShellExecuteW(NULL,"open",buy3,NULL,NULL,1); SINGB=False;}
              }             
               if(OrderLots() == 0.27){
                    if(SINGB){ShellExecuteW(NULL,"open",buy4,NULL,NULL,1); SINGB=False;}
              }
               if(OrderLots() == 0.81){
                    if(SINGB){ShellExecuteW(NULL,"open",buy5,NULL,NULL,1); SINGB=False;}
              }                          
           }
           //-----------------------------------------------------------------------
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL){SellOpen++;
              if(OrderLots()==0.03){
                    if(SINGS){ShellExecuteW(NULL,"open",sell2,NULL,NULL,1); SINGS=False;}
              }
              if(OrderLots()==0.09){
                    if(SINGS){ShellExecuteW(NULL,"open",sell3,NULL,NULL,1); SINGS=False;}
              }
              if(OrderLots()==0.27){
                    if(SINGS){ShellExecuteW(NULL,"open",sell4,NULL,NULL,1); SINGS=False;}
              }
               if(OrderLots()==0.81){
                    if(SINGS){ShellExecuteW(NULL,"open",sell5,NULL,NULL,1); SINGS=False;}
              }                                         
           } 
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
if(SellOpen==1){SELL_TP();}else{SINGS=True;}
if(BuyOpen==1){BUY_TP();}else{SINGB=True;}
     if(SAR1 > Open[1] && SAR0 < Open[1] ){
                   if(lastbar!=Bars){
                             if(BuyOpen==0){if(spd <= Allow_Spred){OpenBuy();}}
                   }         
     }
      if(SAR1 < Open[1] && SAR0 > Open[1]){
                   if(lastbar!=Bars){
                              if(SellOpen==0){ if(spd <= Allow_Spred){ OpenSell();}}                  
                   }                   
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
void SELL_TP(){ 
bool res;
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

//----------------------------------------------------------------------------------------------------------------------------- 



void OnTick(){ 
Treding();
}
//----------------------------------------------------------------------------------------------------------

