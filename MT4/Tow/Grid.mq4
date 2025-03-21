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
extern double LotsXponent =1.1;
double LotsD =Lots;
int SL =80000;
extern int TP =500;
extern int Grid_Minimun =500;
extern int MagicNumber =1001;
extern int Slippage =1000;
extern bool Enable_TrailingStop =True;
extern int TralingStart_After_Profit =500;
extern int TralingStep =200;
int ticket,BuyOpen,SellOpen; 
double mark,BuyOpenProfit,SellOpenProfit,bb;
double B=AccountBalance(); 
extern string extoken = "6Cpi4vZIHB6xYh9RnCHpgmIzmSe4J5G8hps49dBs1kB" ;
extern bool Notify =false;
enum Tred {Sell=0,Buy=1};
extern Tred OpenOrder=Buy;
extern double Taget_to_Stop_treding=0.0;

//----------------------------------------------------------------------------------------------------------
void Openbuy(){
  ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,Ask+TP*Point,"",MagicNumber,0,clrNONE);
}
//---------------------------
void OpenSell(){
  ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,Bid+SL*Point,Bid-TP*Point,"",MagicNumber,0,clrNONE);
}
//-----------------------------
 

 
 void GetStat(){ SellOpen=0; BuyOpen=0; BuyOpenProfit=0; SellOpenProfit=0;
 bool res;
     for(int i = 0;i < OrdersTotal();i++){  
     res = OrderSelect(i,SELECT_BY_POS);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL){SellOpen++;
           Lots = OrderLots();mark=OrderOpenPrice(); SellOpenProfit+=OrderProfit()+OrderSwap();
           }
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY){BuyOpen++;
           Lots = OrderLots(); mark=OrderOpenPrice(); BuyOpenProfit+=OrderProfit()+OrderSwap();
           }
    
      }   
}   

//--------------------------------------------------------------------------------------------------  
void Treding(){ GetStat();
     if(SellOpen==0 || BuyOpen==0){
       Lots=LotsD;
       if(Taget_to_Stop_treding != 0){
           if(SellOpen==0){ if(OpenOrder==0){if(Ask > Taget_to_Stop_treding){OpenSell();}}}
           if(BuyOpen==0){ if(OpenOrder==1){if(Bid < Taget_to_Stop_treding){Openbuy();}}}
       }
    } 
       
                       if(OpenOrder==0){GetStat();
                                 if(Bid > mark+Grid_Minimun*Point){Lots=Lots*LotsXponent;OpenSell();}
                       }
                       if(OpenOrder==1){GetStat();
                                 if(Ask < mark-Grid_Minimun*Point){Lots=Lots*LotsXponent;Openbuy();}
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
void eng(){
ObjectCreate("0", OBJ_BUTTON, 0, 0, 0);
ObjectSet("0", OBJPROP_XDISTANCE, 2);
ObjectSet("0", OBJPROP_YDISTANCE, 2);
ObjectSet("0", OBJPROP_XSIZE, 220);
ObjectSet("0", OBJPROP_YSIZE, 300);
ObjectSet("0", OBJPROP_BORDER_COLOR,clrMediumBlue);
ObjectSet("0", OBJPROP_BGCOLOR,clrBlack);
ObjectSetText("0","", 20, NULL, clrNONE);

ObjectCreate("1", OBJ_LABEL, 0, 0, 0);
ObjectSetText("1","Grid Systems", 20, NULL, clrMagenta);
ObjectSet("1", OBJPROP_XDISTANCE, 20);
ObjectSet("1", OBJPROP_YDISTANCE, 20);

ObjectCreate("2", OBJ_LABEL, 0, 0, 0);if(OpenOrder==1){
ObjectSetText("2",StringFormat("BuyOpen = %G",BuyOpen), 15, NULL, clrBisque);}else{
ObjectSetText("2",StringFormat("SellOpen = %G",SellOpen), 15, NULL, clrBisque); }
ObjectSet("2", OBJPROP_XDISTANCE,20);
ObjectSet("2", OBJPROP_YDISTANCE, 70);

ObjectCreate("3", OBJ_LABEL, 0, 0, 0);if(OpenOrder==1){
ObjectSetText("3",StringFormat("BuyProfit = %G",BuyOpenProfit), 15,NULL, clrDarkGray);}else{
ObjectSetText("3",StringFormat("SellProfit = %G",SellOpenProfit), 15,NULL, clrDarkGray);}
ObjectSet("3", OBJPROP_XDISTANCE, 20);
ObjectSet("3", OBJPROP_YDISTANCE, 100);

ObjectCreate("4", OBJ_LABEL, 0, 0, 0);
ObjectSetText("4",StringFormat("Equity = %G",AccountEquity()), 15,NULL, clrSienna);
ObjectSet("4", OBJPROP_XDISTANCE, 20);
ObjectSet("4", OBJPROP_YDISTANCE, 130);

ObjectCreate("5", OBJ_LABEL, 0, 0, 0);
ObjectSetText("5",StringFormat("Balance = %G",AccountBalance()), 15,NULL, clrAqua);
ObjectSet("5", OBJPROP_XDISTANCE, 20);
ObjectSet("5", OBJPROP_YDISTANCE, 160);

ObjectCreate("6", OBJ_LABEL, 0, 0, 0);
ObjectSetText("6",StringFormat("Price Target=%G",Taget_to_Stop_treding), 15,NULL, clrGreenYellow);
ObjectSet("6", OBJPROP_XDISTANCE, 20);
ObjectSet("6", OBJPROP_YDISTANCE, 190);



}
//----------------------------------------------------------------------
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
void OnTick(){
eng();
if(Enable_TrailingStop)TrailingStop(); 
Treding();
if(Notify)sendline();
}
//----------------------------------------------------------------------------------------------------------

