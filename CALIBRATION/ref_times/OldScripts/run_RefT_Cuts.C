// Stephen Kay - University of Regina - 25/06/20 // 

#include <TProof.h>
#include <iostream>
#include <fstream>
#include <string>
#include <stdio.h>

void run_RefT_Cuts(string RunPrefix = "", Int_t RunNumber = 0, Int_t MaxEvent = 0)
{
  cout << "Script to plot detector reference times" << endl;
  cout << "Input is RootfilePrefix, run number and number of events" << endl;
  TString Hostname = gSystem->HostName();
  TString User = (gSystem->GetUserInfo())->fUser;
  TString RunPref;
  TString rootFileNameString;
  TString Rootpath;
  TString Outpath;
  TString Histopath;
 
  RunPref = RunPrefix;
  if(RunPref == "") {
    cout << "Enter a Rootfile name prefix (Assumed format is PREFIX_RUN#_#EVENTS.root): ";
    cin >> RunPrefix;
    RunPref = RunPrefix;
  }
  if (RunNumber == 0)
    {
      cout << "Enter a Run Number (-1 to exit): ";
      cin >> RunNumber;
      if (RunNumber <= 0) return;
    }  
  if(MaxEvent == 0) {
    cout << "\nNumber of Events to analyze: ";
    cin >> MaxEvent;
    if(MaxEvent == 0) {
      cerr << "...Invalid entry\n";
      return;
    }
  }

  cin.ignore(numeric_limits<streamsize>::max(), '\n');

  if(Hostname.Contains("farm")){
    Rootpath = "/group/c-pionlt/USERS/"+User+"/hallc_replay_lt/ROOTfiles/Calib/Timing/";
    Outpath = "/group/c-pionlt/USERS/"+User+"/hallc_replay_lt/OUTPUT/Calib/Timing/";
    Histopath = "/group/c-pionlt/USERS/"+User+"/hallc_replay_lt/HISTOGRAMS/Calib/Timing/";
  }
  else if(Hostname.Contains("qcd")){
    Rootpath = "/group/c-pionlt/USERS/"+User+"/hallc_replay_lt/ROOTfiles/Calib/Timing/";
    Outpath = "/group/c-pionlt/USERS/"+User+"/hallc_replay_lt/OUTPUT/Calib/Timing/";
    Histopath = "/group/c-pionlt/USERS/"+User+"/hallc_replay_lt/HISTOGRAMS/Calib/Timing/";
  }
  // Need to change this, probably expliticly require a ROOTfile name as an argument in future (Or just the file prefix)
  else if (Hostname.Contains("phys.uregina.ca")){
    Rootpath = "/dsk3/"+User+"/JLab/ROOTfiles/Calib/Timing/";
    Outpath = "/dsk3/"+User+"/JLab/OUTPUT/Calib/Timing/";
    Histopath = "/dsk3/"+User+"/JLab/HISTOGRAMS/Calib/Timing/";
  }
  rootFileNameString = Rootpath + Form("%s%i_%i.root", RunPrefix.c_str(), RunNumber, MaxEvent);
  if (gSystem->AccessPathName(rootFileNameString) == kTRUE){
    cerr << "!!!!! ERROR !!!!! " << endl << rootFileNameString <<  " not found" << endl <<  "!!!!! ERRROR !!!!!" << endl;
    return;
  }
  // Should process a different script for COIN/HMS/SHMS
  TChain ch("T");
  ch.Add(rootFileNameString);
  TString option = Form("%i.Coin", RunNumber);
  TProof *proof = TProof::Open("workers=4");
  ch.SetProof();
  ch.Process("DetRefT_Cuts.C+",option);
  proof->Close();
}
