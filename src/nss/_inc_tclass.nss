//*******************************************************//
//** ADCK's advanced treasure database. 18th Aug 2005. **//
//*******************************************************//
string MakeTClass(int TCNum);
string AssignRandomPotionResRef(int PotClass);
string AssignRandomScrollResRef(int ScrollClass);
string AssignKitResRef(int KitClass);
string AssignGemResRef(int GemClass);

//void main(){}

string MakeTClass(int TCNum){
    string s;

//-----TREASURE CLASS 1

        if(TCNum == 1){
            switch(Random(2))
            {
            /*add items below. for every item you add to this make a new case
            line and raise the number above to the max case stated(highest case below)
            be sure there isnt any gaps!(dont skip numbers)
            these first 2 entries are to get you started.
            simply place the resref for the item in the "".
            after that make new cases and raise the random number generator
            for the treasure class accordingly*/
                case 0: s = ""; break;
                case 1: s = ""; break;
            }
        }

//-----TREASURE CLASS 2

        else if(TCNum == 2){
            switch(Random(2))
            {
                case 0: s = ""; break;
                case 1: s = ""; break;
            }
        }

//-----TREASURE CLASS 3

        else if(TCNum == 3){
            switch(Random(2))
            {
                case 0: s = ""; break;
                case 1: s = ""; break;
            }
        }

//-----TREASURE CLASS 4

        else if(TCNum == 4){
            switch(Random(2))
            {
                case 0: s = ""; break;
                case 1: s = ""; break;
            }
        }

//-----TREASURE CLASS 5

        else if(TCNum == 5){
            switch(Random(2))
            {
                case 0: s = ""; break;
                case 1: s = ""; break;
            }
        }

//-----TREASURE CLASS 6

        else if(TCNum == 6){
            switch(Random(2))
            {
                case 0: s = ""; break;
                case 1: s = ""; break;
            }
        }

//-----TREASURE CLASS 7

        else if(TCNum == 7){
            switch(Random(2))
            {
                case 0: s = ""; break;
                case 1: s = ""; break;
            }
        }

//-----TREASURE CLASS 8

        else if(TCNum == 8){
            switch(Random(2))
            {
                case 0: s = ""; break;
                case 1: s = ""; break;
            }
        }

//-----TREASURE CLASS 9

        else if(TCNum == 9){
            switch(Random(2))
            {
                case 0: s = ""; break;
                case 1: s = ""; break;
            }
        }

//-----TREASURE CLASS 10

        else if(TCNum == 10){
            switch(Random(2))
            {
                case 0: s = ""; break;
                case 1: s = ""; break;
            }
        }

//-----TREASURE CLASS 11

        else if(TCNum == 11){
            switch(Random(2))
            {
                case 0: s = ""; break;
                case 1: s = ""; break;
            }
        }

//-----TREASURE CLASS 12

        else if(TCNum == 12){
            switch(Random(2))
            {
                case 0: s = ""; break;
                case 1: s = ""; break;
            }
        }

//-----TREASURE CLASS 13

        else if(TCNum == 13){
            switch(Random(2))
            {
                case 0: s = ""; break;
                case 1: s = ""; break;
            }
        }

//-----TREASURE CLASS 14

        else if(TCNum == 14){
            switch(Random(2))
            {
                case 0: s = ""; break;
                case 1: s = ""; break;
            }
        }

//-----TREASURE CLASS 15

        else if(TCNum == 15){
            switch(Random(2))
            {
                case 0: s = ""; break;
                case 1: s = ""; break;
            }
        }

//-----TREASURE CLASS 16

        else if(TCNum == 16){
            switch(Random(2))
            {
                case 0: s = ""; break;
                case 1: s = ""; break;
            }
        }

//-----TREASURE CLASS 17

        else if(TCNum == 17){
            switch(Random(2))
            {
                case 0: s = ""; break;
                case 1: s = ""; break;
            }
        }

//-----TREASURE CLASS 18

        else if(TCNum == 18){
            switch(Random(2))
            {
                case 0: s = ""; break;
                case 1: s = ""; break;
            }
        }

//-----TREASURE CLASS 19

        else if(TCNum == 19){
            switch(Random(2))
            {
                case 0: s = ""; break;
                case 1: s = ""; break;
            }
        }

//-----TREASURE CLASS 20

        else if(TCNum == 20){
            switch(Random(2))
            {
                case 0: s = ""; break;
                case 1: s = ""; break;
            }
        }

//-----TREASURE CLASS 21 (rarest stuff here)

        else if(TCNum == 21){
            switch(Random(2))
            {
                case 0: s = ""; break;
                case 1: s = ""; break;
            }
        }
    return s;
}

//potions and other tables work in the same manner as tclass equipment tables exept the classes are scaled differently.

/*string AssignRandomPotionResRef(int PotClass)
{
    string PotionResRef;
    if(PotClass == 1){
            switch(Random(5)){
                case 0: PotionResRef = "starterspeed"; break;
                case 1: PotionResRef = "nw_it_mpotion021"; break;
                case 2: PotionResRef = "nw_it_mpotion022"; break;
                case 3: PotionResRef = "nw_it_mpotion023"; break;
                case 4: PotionResRef = "nw_it_mpotion001"; break;
            }
    }
    else if(PotClass == 2){
            switch(Random(9)){
                case 0: PotionResRef = "ptn_acidbreat001"; break;
                case 1: PotionResRef = "ptn_elecbreat001"; break;
                case 2: PotionResRef = "ptn_firebreat001"; break;
                case 3: PotionResRef = "ptn_icebreat001"; break;
                case 4: PotionResRef = "starterspeed"; break;
                case 5: PotionResRef = "nw_it_mpotion021"; break;
                case 6: PotionResRef = "nw_it_mpotion022"; break;
                case 7: PotionResRef = "nw_it_mpotion023"; break;
                case 8: PotionResRef = "nw_it_mpotion020"; break;
            }
    }
    else if(PotClass == 3){
            switch(Random(9)){
                case 0: PotionResRef = "ptn_acidbreat001"; break;
                case 1: PotionResRef = "ptn_elecbreat001"; break;
                case 2: PotionResRef = "ptn_firebreat001"; break;
                case 3: PotionResRef = "ptn_icebreat001"; break;
                case 4: PotionResRef = "starterspeed"; break;
                case 5: PotionResRef = "nw_it_mpotion021"; break;
                case 6: PotionResRef = "nw_it_mpotion022"; break;
                case 7: PotionResRef = "nw_it_mpotion023"; break;
                case 8: PotionResRef = "nw_it_mpotion002"; break;
            }
    }
    else if(PotClass == 4){
            switch(Random(15)){
                case 0: PotionResRef = "ptn_acidbreat001"; break;
                case 1: PotionResRef = "ptn_elecbreat001"; break;
                case 2: PotionResRef = "ptn_firebreat001"; break;
                case 3: PotionResRef = "ptn_icebreat001"; break;
                case 4: PotionResRef = "starterspeed"; break;
                case 5: PotionResRef = "nw_it_mpotion021"; break;
                case 6: PotionResRef = "nw_it_mpotion022"; break;
                case 7: PotionResRef = "nw_it_mpotion023"; break;
                case 8: PotionResRef = "nw_it_mpotion003"; break;
                case 9: PotionResRef = "ptn_herocha"; break;
                case 10: PotionResRef = "ptn_herocon"; break;
                case 11: PotionResRef = "ptn_herodex"; break;
                case 12: PotionResRef = "ptn_heroint"; break;
                case 13: PotionResRef = "ptn_herostr"; break;
                case 14: PotionResRef = "ptn_herowis"; break;
            }
    }
    else{
            switch(Random(57)){
                case 0: PotionResRef = "ptn_acidbreat001"; break;
                case 1: PotionResRef = "ptn_elecbreat001"; break;
                case 2: PotionResRef = "ptn_firebreat001"; break;
                case 3: PotionResRef = "ptn_icebreat001"; break;
                case 4: PotionResRef = "starterspeed"; break;
                case 5: PotionResRef = "it_mpotion003"; break;
                case 6: PotionResRef = "it_mpotion005"; break;
                case 7: PotionResRef = "it_mpotion007"; break;
                case 8: PotionResRef = "it_mpotion008"; break;
                case 9: PotionResRef = "it_mpotion009"; break;
                case 10: PotionResRef = "it_mpotion010"; break;
                case 11: PotionResRef = "it_mpotion011"; break;
                case 12: PotionResRef = "it_mpotion013"; break;
                case 13: PotionResRef = "nw_it_mpotion021"; break;
                case 14: PotionResRef = "nw_it_mpotion022"; break;
                case 15: PotionResRef = "nw_it_mpotion023"; break;
                case 16: PotionResRef = "nw_it_mpotion003"; break;
                case 17: PotionResRef = "nw_it_mpotion016"; break;
                case 18: PotionResRef = "nw_it_mpotion006"; break;
                case 19: PotionResRef = "nw_it_mpotion005"; break;
                case 20: PotionResRef = "nw_it_mpotion009"; break;
                case 21: PotionResRef = "nw_it_mpotion015"; break;
                case 22: PotionResRef = "nw_it_mpotion014"; break;
                case 23: PotionResRef = "nw_it_mpotion007"; break;
                case 24: PotionResRef = "nw_it_mpotion013"; break;
                case 25: PotionResRef = "nw_it_mpotion017"; break;
                case 26: PotionResRef = "nw_it_mpotion008"; break;
                case 27: PotionResRef = "nw_it_mpotion011"; break;
                case 28: PotionResRef = "nw_it_mpotion018"; break;
                case 29: PotionResRef = "nw_it_mpotion019"; break;
                case 30: PotionResRef = "nw_it_mpotion004"; break;
                case 31: PotionResRef = "ptn_displace"; break;
                case 32: PotionResRef = "ptn_burnretort"; break;
                case 33: PotionResRef = "ptn_clairvoy"; break;
                case 34: PotionResRef = "ptn_command"; break;
                case 35: PotionResRef = "ptn_drowsight"; break;
                case 36: PotionResRef = "ptn_earthprt"; break;
                case 37: PotionResRef = "ptn_eavesdrop"; break;
                case 38: PotionResRef = "ptn_fury"; break;
                case 39: PotionResRef = "ptn_herocha"; break;
                case 40: PotionResRef = "ptn_herocon"; break;
                case 41: PotionResRef = "ptn_herodex"; break;
                case 42: PotionResRef = "ptn_heroint"; break;
                case 43: PotionResRef = "ptn_herostr"; break;
                case 44: PotionResRef = "ptn_herowis"; break;
                case 45: PotionResRef = "ptn_heroism"; break;
                case 46: PotionResRef = "ptn_traploc"; break;
                case 47: PotionResRef = "ptn_majelres"; break;
                case 48: PotionResRef = "ptn_minelres"; break;
                case 49: PotionResRef = "ptn_mystprot"; break;
                case 50: PotionResRef = "ptn_shielding"; break;
                case 51: PotionResRef = "ptn_negprot"; break;
                case 52: PotionResRef = "ptn_stingret"; break;
                case 53: PotionResRef = "ptn_superhero"; break;
                case 54: PotionResRef = "ptn_unfettered"; break;
                case 55: PotionResRef = "ptn_rallycry"; break;
                case 56: PotionResRef = "ptn_rogscunn"; break;
            }
    }
    return PotionResRef;
}
*/
/*string AssignRandomScrollResRef(int ScrollClass){
    string ScrollResRef;
    if(ScrollClass == 1){
            switch(Random(57)){
                case 0: ScrollResRef = "it_spdvscr302"; break;
                case 1: ScrollResRef = "extendedhaste"; break;
                case 2: ScrollResRef = "nw_it_spdvscr203"; break;
                case 3: ScrollResRef = "nw_it_spdvscr301"; break;
                case 4: ScrollResRef = "nw_it_spdvscr302"; break;
                case 5: ScrollResRef = "nw_it_sparscr211"; break;
                case 6: ScrollResRef = "nw_it_sparscr212"; break;
                case 7: ScrollResRef = "nw_it_sparscr112"; break;
                case 8: ScrollResRef = "nw_it_sparscr213"; break;
                case 9: ScrollResRef = "nw_it_sparscr217"; break;
                case 10: ScrollResRef = "nw_it_sparscr110"; break;
                case 11: ScrollResRef = "nw_it_sparscr003"; break;
                case 12: ScrollResRef = "nw_it_sparscr301"; break;
                case 13: ScrollResRef = "nw_it_sparscr219"; break;
                case 14: ScrollResRef = "nw_it_sparscr101"; break;
                case 15: ScrollResRef = "nw_it_sparscr220"; break;
                case 16: ScrollResRef = "nw_it_sparscr208"; break;
                case 17: ScrollResRef = "nw_it_sparscr106"; break;
                case 18: ScrollResRef = "nw_it_sparscr207"; break;
                case 19: ScrollResRef = "nw_it_sparscr218"; break;
                case 20: ScrollResRef = "nw_it_sparscr004"; break;
                case 21: ScrollResRef = "nw_it_sparscr104"; break;
                case 22: ScrollResRef = "nw_it_sparscr109"; break;
                case 23: ScrollResRef = "nw_it_sparscr402"; break;
                case 24: ScrollResRef = "nw_it_sparscr201"; break;
                case 25: ScrollResRef = "nw_it_sparscr001"; break;
                case 26: ScrollResRef = "nw_it_sparscr205"; break;
                case 27: ScrollResRef = "nw_it_sparscr105"; break;
                case 28: ScrollResRef = "nw_it_sparscr203"; break;
                case 29: ScrollResRef = "nw_it_sparscr214"; break;
                case 30: ScrollResRef = "nw_it_sparscr206"; break;
                case 31: ScrollResRef = "nw_it_sparscr107"; break;
                case 32: ScrollResRef = "nw_it_sparscr103"; break;
                case 33: ScrollResRef = "nw_it_sparscr102"; break;
                case 34: ScrollResRef = "nw_it_sparscr108"; break;
                case 35: ScrollResRef = "nw_it_sparscr209"; break;
                case 36: ScrollResRef = "nw_it_sparscr204"; break;
                case 37: ScrollResRef = "nw_it_sparscr002"; break;
                case 38: ScrollResRef = "nw_it_sparscr216"; break;
                case 39: ScrollResRef = "x1_it_spdvscr103"; break;
                case 40: ScrollResRef = "x1_it_spdvscr301"; break;
                case 41: ScrollResRef = "x1_it_sparscr101"; break;
                case 42: ScrollResRef = "x1_it_sparscr102"; break;
                case 43: ScrollResRef = "x1_it_sparscr103"; break;
                case 44: ScrollResRef = "x1_it_sparscr201"; break;
                case 45: ScrollResRef = "x1_it_sparscr202"; break;
                case 46: ScrollResRef = "x1_it_sparscr303"; break;
                case 47: ScrollResRef = "x2_it_spdvscr107"; break;
                case 48: ScrollResRef = "x2_it_spdvscr204"; break;
                case 49: ScrollResRef = "x2_it_spdvscr205"; break;
                case 50: ScrollResRef = "x2_it_sparscr101"; break;
                case 51: ScrollResRef = "x2_it_sparscr102"; break;
                case 52: ScrollResRef = "x2_it_sparscr105"; break;
                case 53: ScrollResRef = "x2_it_sparscr202"; break;
                case 54: ScrollResRef = "x2_it_sparscr205"; break;
                case 55: ScrollResRef = "x2_it_sparscr203"; break;
                case 56: ScrollResRef = "x2_it_sparscr305"; break;
            }
    }
    else if(ScrollClass == 2){
            switch(Random(25)){
                case 0: ScrollResRef = "nw_it_sparscr509"; break;
                case 1: ScrollResRef = "nw_it_sparscr307"; break;
                case 2: ScrollResRef = "nw_it_sparscr217"; break;
                case 3: ScrollResRef = "nw_it_sparscr301"; break;
                case 4: ScrollResRef = "nw_it_sparscr309"; break;
                case 5: ScrollResRef = "nw_it_sparscr304"; break;
                case 6: ScrollResRef = "nw_it_sparscr312"; break;
                case 7: ScrollResRef = "nw_it_sparscr308"; break;
                case 8: ScrollResRef = "nw_it_sparscr314"; break;
                case 9: ScrollResRef = "nw_it_sparscr310"; break;
                case 10: ScrollResRef = "nw_it_sparscr302"; break;
                case 11: ScrollResRef = "nw_it_sparscr315"; break;
                case 12: ScrollResRef = "nw_it_sparscr303"; break;
                case 13: ScrollResRef = "nw_it_sparscr313"; break;
                case 14: ScrollResRef = "nw_it_sparscr305"; break;
                case 15: ScrollResRef = "nw_it_sparscr306"; break;
                case 16: ScrollResRef = "nw_it_sparscr311"; break;
                case 17: ScrollResRef = "x1_it_sparscr301"; break;
                case 18: ScrollResRef = "x1_it_sparscr303"; break;
                case 19: ScrollResRef = "x2_it_sparscr301"; break;
                case 20: ScrollResRef = "x2_it_sparscr302"; break;
                case 21: ScrollResRef = "x2_it_sparscr303"; break;
                case 22: ScrollResRef = "x2_it_sparscr304"; break;
                case 23: ScrollResRef = "x2_it_sparscr305"; break;
                case 24: ScrollResRef = "x2_it_spdvscr310"; break;
            }
    }
    else if(ScrollClass == 3){
            switch(Random(40)){
                case 0: ScrollResRef = "nw_it_sparscr414"; break;
                case 1: ScrollResRef = "nw_it_sparscr405"; break;
                case 2: ScrollResRef = "nw_it_sparscr406"; break;
                case 3: ScrollResRef = "nw_it_sparscr411"; break;
                case 4: ScrollResRef = "nw_it_sparscr412"; break;
                case 5: ScrollResRef = "nw_it_sparscr418"; break;
                case 6: ScrollResRef = "nw_it_sparscr413"; break;
                case 7: ScrollResRef = "nw_it_sparscr408"; break;
                case 8: ScrollResRef = "nw_it_sparscr417"; break;
                case 9: ScrollResRef = "nw_it_sparscr401"; break;
                case 10: ScrollResRef = "nw_it_sparscr409"; break;
                case 11: ScrollResRef = "nw_it_sparscr415"; break;
                case 12: ScrollResRef = "nw_it_sparscr402"; break;
                case 13: ScrollResRef = "nw_it_sparscr410"; break;
                case 14: ScrollResRef = "nw_it_sparscr403"; break;
                case 15: ScrollResRef = "nw_it_sparscr404"; break;
                case 16: ScrollResRef = "nw_it_sparscr407"; break;
                case 17: ScrollResRef = "nw_it_sparscr502"; break;
                case 18: ScrollResRef = "nw_it_sparscr507"; break;
                case 19: ScrollResRef = "nw_it_sparscr501"; break;
                case 20: ScrollResRef = "nw_it_sparscr503"; break;
                case 21: ScrollResRef = "nw_it_sparscr416"; break;
                case 22: ScrollResRef = "nw_it_sparscr504"; break;
                case 23: ScrollResRef = "nw_it_sparscr508"; break;
                case 24: ScrollResRef = "nw_it_sparscr505"; break;
                case 25: ScrollResRef = "nw_it_sparscr511"; break;
                case 26: ScrollResRef = "nw_it_sparscr512"; break;
                case 27: ScrollResRef = "nw_it_sparscr513"; break;
                case 28: ScrollResRef = "nw_it_sparscr506"; break;
                case 29: ScrollResRef = "nw_it_sparscr510"; break;
                case 30: ScrollResRef = "nw_it_spdvscr301"; break;
                case 31: ScrollResRef = "x1_it_sparscr401"; break;
                case 32: ScrollResRef = "x1_it_sparscr501"; break;
                case 33: ScrollResRef = "x1_it_sparscr502"; break;
                case 34: ScrollResRef = "x1_it_sparscr604"; break;
                case 35: ScrollResRef = "x2_it_sparscr401"; break;
                case 36: ScrollResRef = "x2_it_sparscr501"; break;
                case 37: ScrollResRef = "x2_it_sparscr502"; break;
                case 38: ScrollResRef = "x2_it_sparscr503"; break;
                case 39: ScrollResRef = "x2_it_spdvscr507"; break;
            }
    }
    else if(ScrollClass == 4){
            switch(Random(25)){
                case 0: ScrollResRef = "nw_it_sparscr603"; break;
                case 1: ScrollResRef = "nw_it_sparscr610"; break;
                case 2: ScrollResRef = "nw_it_sparscr608"; break;
                case 3: ScrollResRef = "nw_it_sparscr604"; break;
                case 4: ScrollResRef = "nw_it_sparscr609"; break;
                case 5: ScrollResRef = "nw_it_sparscr606"; break;
                case 6: ScrollResRef = "nw_it_sparscr707"; break;
                case 7: ScrollResRef = "nw_it_sparscr704"; break;
                case 8: ScrollResRef = "nw_it_sparscr708"; break;
                case 9: ScrollResRef = "nw_it_sparscr705"; break;
                case 10: ScrollResRef = "nw_it_sparscr702"; break;
                case 11: ScrollResRef = "nw_it_sparscr706"; break;
                case 12: ScrollResRef = "nw_it_sparscr607"; break;
                case 13: ScrollResRef = "nw_it_sparscr602"; break;
                case 14: ScrollResRef = "nw_it_sparscr611"; break;
                case 15: ScrollResRef = "nw_it_sparscr605"; break;
                case 16: ScrollResRef = "nw_it_sparscr614"; break;
                case 17: ScrollResRef = "x1_it_sparscr602"; break;
                case 18: ScrollResRef = "x1_it_sparscr701"; break;
                case 19: ScrollResRef = "x1_it_spdvscr601"; break;
                case 20: ScrollResRef = "x2_it_sparscr601"; break;
                case 21: ScrollResRef = "x2_it_sparscr602"; break;
                case 22: ScrollResRef = "x2_it_sparscr702"; break;
                case 23: ScrollResRef = "x2_it_sparscr703"; break;
                case 24: ScrollResRef = "x2_it_spdvscr509"; break;
            }
    }
    else if(ScrollClass == 5){
            switch(Random(22)){
                case 0: ScrollResRef = "nw_it_sparscr801"; break;
                case 1: ScrollResRef = "nw_it_sparscr803"; break;
                case 2: ScrollResRef = "nw_it_sparscr804"; break;
                case 3: ScrollResRef = "nw_it_sparscr805"; break;
                case 4: ScrollResRef = "nw_it_sparscr806"; break;
                case 5: ScrollResRef = "nw_it_sparscr807"; break;
                case 6: ScrollResRef = "nw_it_sparscr809"; break;
                case 7: ScrollResRef = "nw_it_sparscr901"; break;
                case 8: ScrollResRef = "nw_it_sparscr902"; break;
                case 9: ScrollResRef = "nw_it_sparscr904"; break;
                case 10: ScrollResRef = "nw_it_sparscr905"; break;
                case 11: ScrollResRef = "nw_it_sparscr907"; break;
                case 12: ScrollResRef = "nw_it_sparscr908"; break;
                case 13: ScrollResRef = "nw_it_sparscr910"; break;
                case 14: ScrollResRef = "x1_it_sparscr801"; break;
                case 15: ScrollResRef = "x1_it_sparscr901"; break;
                case 16: ScrollResRef = "x1_it_spdvscr602"; break;
                case 17: ScrollResRef = "x1_it_spdvscr605"; break;
                case 18: ScrollResRef = "x1_it_spdvscr802"; break;
                case 19: ScrollResRef = "x2_it_sparscr901"; break;
                case 20: ScrollResRef = "x2_it_sparscr902"; break;
                case 21: ScrollResRef = "x2_it_spdvscr606"; break;
            }
    }
    return ScrollResRef;
}
*/
string AssignKitResRef(int KitClass){
    string KitResRef;
         if(KitClass == 1){KitResRef = "it_medkit002";}
    else if(KitClass == 2){KitResRef = "it_medkit007";}
    else if(KitClass == 3){KitResRef = "it_medkit003";}
    else if(KitClass == 4){KitResRef = "it_medkit008";}
         return KitResRef;
}

string AssignGemResRef(int GemClass){
    string GemResRef;
    if(GemClass == 1){
        switch(Random(6)){
            case 0: GemResRef = "NW_IT_GEM007"; break;
            case 1: GemResRef = "NW_IT_GEM004"; break;
            case 2: GemResRef = "NW_IT_GEM014"; break;
            case 3: GemResRef = "NW_IT_GEM003"; break;
            case 4: GemResRef = "NW_IT_GEM002"; break;
            case 5: GemResRef = "NW_IT_GEM015"; break;
            case 6: GemResRef = "NW_IT_GEM001"; break;
        }
    }
    else if(GemClass == 2){
        switch(Random(6)){
            case 0: GemResRef = "NW_IT_GEM004"; break;
            case 1: GemResRef = "NW_IT_GEM014"; break;
            case 2: GemResRef = "NW_IT_GEM003"; break;
            case 3: GemResRef = "NW_IT_GEM002"; break;
            case 4: GemResRef = "NW_IT_GEM015"; break;
            case 5: GemResRef = "NW_IT_GEM011"; break;
            case 6: GemResRef = "NW_IT_GEM013"; break;

        }
    }
    else if(GemClass == 3){
        switch(Random(6)){
            case 0: GemResRef = "Amber"; break;
            case 1: GemResRef = "NW_IT_GEM014"; break;
            case 2: GemResRef = "NW_IT_GEM003"; break;
            case 3: GemResRef = "NW_IT_GEM010"; break;
            case 4: GemResRef = "NW_IT_GEM015"; break;
            case 5: GemResRef = "NW_IT_GEM011"; break;
            case 6: GemResRef = "NW_IT_GEM013"; break;
        }
    }
    else if(GemClass == 4){
        switch(Random(6)){
            case 0: GemResRef = "Amber"; break;
            case 1: GemResRef = "Aquamarine"; break;
            case 2: GemResRef = "KingStone"; break;
            case 3: GemResRef = "NW_IT_GEM010"; break;
            case 4: GemResRef = "NW_IT_GEM015"; break;
            case 5: GemResRef = "NW_IT_GEM011"; break;
            case 6: GemResRef = "NW_IT_GEM013"; break;
        }
    }
    else if(GemClass == 5){
        switch(Random(6)){
            case 0: GemResRef = "Amber"; break;
            case 1: GemResRef = "Aquamarine"; break;
            case 2: GemResRef = "KingStone"; break;
            case 3: GemResRef = "NW_IT_GEM010"; break;
            case 4: GemResRef = "Jade"; break;
            case 5: GemResRef = "Tourmaline"; break;
            case 6: GemResRef = "NW_IT_GEM013"; break;
        }
    }
    else if(GemClass == 6){
        switch(Random(6)){
            case 0: GemResRef = "Amber"; break;
            case 1: GemResRef = "Aquamarine"; break;
            case 2: GemResRef = "KingStone"; break;
            case 3: GemResRef = "Opal"; break;
            case 4: GemResRef = "Jade"; break;
            case 5: GemResRef = "Tourmaline"; break;
            case 6: GemResRef = "Pearl"; break;
        }
    }
    else if(GemClass == 7){
        switch(Random(6)){
            case 0: GemResRef = "NW_IT_GEM008"; break;
            case 1: GemResRef = "Aquamarine"; break;
            case 2: GemResRef = "KingStone"; break;
            case 3: GemResRef = "Opal"; break;
            case 4: GemResRef = "Jade"; break;
            case 5: GemResRef = "Tourmaline"; break;
            case 6: GemResRef = "Pearl"; break;
        }
    }
    else if(GemClass == 8){
        switch(Random(6)){
            case 0: GemResRef = "NW_IT_GEM008"; break;
            case 1: GemResRef = "NW_IT_GEM009"; break;
            case 2: GemResRef = "KingStone"; break;
            case 3: GemResRef = "Opal"; break;
            case 4: GemResRef = "Jade"; break;
            case 5: GemResRef = "Tourmaline"; break;
            case 6: GemResRef = "Pearl"; break;
        }
    }
    else if(GemClass == 9){
        switch(Random(6)){
            case 0: GemResRef = "NW_IT_GEM008"; break;
            case 1: GemResRef = "NW_IT_GEM009"; break;
            case 2: GemResRef = "NW_IT_GEM005"; break;
            case 3: GemResRef = "Opal"; break;
            case 4: GemResRef = "Jade"; break;
            case 5: GemResRef = "NW_IT_GEM006"; break;
            case 6: GemResRef = "Pearl"; break;
        }
    }
    else if(GemClass ==10){
        switch(Random(6)){
            case 0: GemResRef = "starsapphire"; break;
            case 1: GemResRef = "perfectruby"; break;
            case 2: GemResRef = "pinkdiamond"; break;
            case 3: GemResRef = "perfectruby"; break;
            case 4: GemResRef = "ForceCrystal"; break;
            case 5: GemResRef = "starsapphire"; break;
            case 6: GemResRef = "starrose"; break;
        }
    }
        return GemResRef;
}
