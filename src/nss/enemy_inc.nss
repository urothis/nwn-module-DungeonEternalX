int EnemyGetIsInList(string sList, string sEnemy);
string EnemyAddToList(string sList, string sEnemy);
string EnemyRemoveFromList(string sList, string sEnemy);

string EnemyAddToList(string sList, string sEnemy)
{
    return (sList == "") ? "|" + sEnemy + "|" : sList + sEnemy + "|";
}

string EnemyRemoveFromList(string sList, string sEnemy)
{
    sEnemy = "|" + sEnemy + "|";
    int nPos = FindSubString(sList, sEnemy);
    if (nPos >= 0)
    {
        string sNew = GetStringLeft(sList, nPos) + GetStringRight(sList, GetStringLength(sList) - (nPos + GetStringLength(sEnemy) - 1));
        return (sNew == "|") ? "" : sNew;
    }
    else return sList;
}

int EnemyGetIsInList(string sList, string sEnemy)
{
    return (FindSubString(sList, "|" + sEnemy + "|") >= 0);
}
//void main(){}
