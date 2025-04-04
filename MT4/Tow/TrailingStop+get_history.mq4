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
//if(Period() != 43200){ChartSetSymbolPeriod(ChartID(),_Symbol,PERIOD_MN1);}
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
extern double Lots =1.0;
extern double LotsXponent =1.5;
double LotsD =Lots;
int SL =80000;
extern int MagicNumber =0;
extern int Slippage =1000;
extern bool Enable_TrailingStop =True;
extern int TralingStart_After_Profit =500;
extern int TralingStep =400;
extern double Parbolic_Step =0.02;
extern double Parbolic_Maximum =0.2;
int ticket,Magic;
double bb;
double B=AccountBalance();
input ENUM_TIMEFRAMES P_Period =PERIOD_H1;
extern string extoken = "6Cpi4vZIHB6xYh9RnCHpgmIzmSe4J5G8hps49dBs1kB" ;
extern bool Notify =false;
//----------------------------------------------------------------------------------------------------------
void Openbuy(){
  ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,"Buy",MagicNumber,0,clrNONE);
}
//---------------------------
void OpenSell(){
  ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,Bid+SL*Point,0,"Sell",MagicNumber,0,clrNONE);
}
//-----------------------------

//-------------------------------------------------------------------------------------------------- 
void  CloseSell(){ 
  bool res;
      for(int i=OrdersTotal()-1;i>=0;i--){
      res = OrderSelect(i,SELECT_BY_POS);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL){
           res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);
           }
          
      }
}  
void  CloseBuy(){ 
  bool res;
      for(int i=OrdersTotal()-1;i>=0;i--){
      res = OrderSelect(i,SELECT_BY_POS);
          if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY){
           res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);
           } 
      }
}  

//-----------------------------------------------------------------------------------------------------  
 void GetMagic(){ Magic=0; 
 bool res;
     for(int i = 0;i < OrdersTotal();i++){  
     res = OrderSelect(i,SELECT_BY_POS);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber){
           Magic=1;
           }
      }   
}   
//-------------------------------------------------------------------------------------------------- 

 void GetLastSell(){ 
 bool res;
     for(int i = 0;i < OrdersHistoryTotal();i++){  
     res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL){
               if(OrderProfit()<0){ Lots =OrderLots()*LotsXponent;}else{Lots=LotsD;}                        
           }            
      }   
}   
 //-----------------------------
 //-------------------------------------------------------------------------------------------------- 

 void GetLastBuy(){
 bool res;
     for(int i = 0;i < OrdersHistoryTotal();i++){  
     res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY){
               if(OrderProfit()<0){ Lots =OrderLots()*LotsXponent;}else{Lots=LotsD;}                      
           }            
      }   
}   
 //-----------------------------

double SAR,SAR1;
void GetIndy(){
  SAR1=iSAR(Symbol(),P_Period,Parbolic_Step,Parbolic_Maximum,1);
  SAR=iSAR(Symbol(),P_Period,Parbolic_Step,Parbolic_Maximum,0); 
}
//--------------------------------------------------------------------------------------------------  
void Treding(){ GetMagic(); 
                if(Magic == 0){GetIndy();
                     if(SAR1 < Open[1] && SAR > Open[0]){ GetLastSell();
                     OpenSell();
                     }
                     if(SAR1 > Open[1] && SAR < Open[0]){ GetLastBuy();
                     Openbuy();
                     }
                }
                if(Magic == 1){GetIndy();
                    if(SAR1 > Open[1] && SAR < Open[0]){CloseSell();}
                    if(SAR1 < Open[1] && SAR > Open[0]){CloseBuy();} 
                }
} 
//----------------------------------------------------------------------------------------------------------  
void TrailingStop(){ bool res;
  for(int i=OrdersTotal()-1;i>=0;i--){
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
          if(OrderSymbol()==Symbol() && OrderMagicNumber() == MagicNumber){
                 if(OrderType() == OP_BUY){
                     if(Bid-OrderOpenPrice() > TralingStart_After_Profit*Point){                 
                         if(OrderStopLoss() < Bid-TralingStep*Point){ 
                          res = OrderModify(OrderTicket(),OrderOpenPrice(),Bid-TralingStep*Point,OrderTakeProfit(),0,0);
                         }
                     }
                     
                 }
                 if(OrderType() == OP_SELL){
                    if(OrderOpenPrice()-Ask > TralingStart_After_Profit*Point){
                        if(OrderStopLoss() > Ask+TralingStep*Point){
                           res = OrderModify(OrderTicket(),OrderOpenPrice(),Ask+TralingStep*Point,OrderTakeProfit(),0,0);                        
                        }
                    }   
                 }
                          
              }       
      }
   } 
}

//-----------------------------------------------------------------------------------------------------------------------------         

void LineNotify(string token,string Massage){
 string headers;
 char post[], result[];

headers="Authorization: Bearer "+token+"\r\n";
 headers+="Content-Type: application/x-www-form-urlencoded\r\n";

ArrayResize(post,StringToCharArray("message="+Massage,post,0,WHOLE_ARRAY,CP_UTF8)-1);

int res = WebRequest("POST", "https://notify-api.line.me/api/notify", headers, 10000, post, result, headers);

Print("Status code: " , res, ", error: ", GetLastError());
 Print("Server response: ", CharArrayToString(result));
}
 
void sendline(){if(AccountBalance() > B){bb=AccountBalance()-B;B=AccountBalance(); LineNotify(extoken," โบรคเกอร์ "+AccountCompany()+" พอร์ท  "+IntegerToString(AccountNumber())+" บวก "+DoubleToString(bb,2)+" USC");}}  

void OnTick(){ if(Period() != P_Period){ChartSetSymbolPeriod(ChartID(),_Symbol,P_Period);}
if(Enable_TrailingStop)TrailingStop(); 
if(Notify)sendline();
Treding();
}
//----------------------------------------------------------------------------------------------------------

