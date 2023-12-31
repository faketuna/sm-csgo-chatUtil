#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdkhooks>

#define PLUGIN_VERSION "0.0.1"

ConVar g_bIgnoreSlash;
ConVar g_bIgnoreFFMessage;
ConVar g_bIgnoreSaveMessage;
ConVar g_bIgnoreJoinMessage;

public Plugin myinfo = 
{
    name = "Chat util",
    author = "faketuna",
    description = "",
    version = PLUGIN_VERSION,
    url = "short.f2a.dev/s/github"
}

public void OnPluginStart()
{
    g_bIgnoreSlash = CreateConVar("sm_ignore_slash", "1", "Ignore the all of chat start with /", FCVAR_RELEASE, true, 0.0, true, 1.0);
    g_bIgnoreFFMessage = CreateConVar("sm_ignore_ff_msg", "1", "Ignore the attacked teammate message", FCVAR_RELEASE, true, 0.0, true, 1.0);
    g_bIgnoreSaveMessage = CreateConVar("sm_ignore_save_msg", "1", "Ignore the saved player message", FCVAR_RELEASE, true, 0.0, true, 1.0);
    g_bIgnoreJoinMessage = CreateConVar("sm_ignore_join_msg", "1", "Ignore the joined team message", FCVAR_RELEASE, true, 0.0, true, 1.0);
    HookUserMessage(GetUserMessageId("TextMsg"), TextMsg, true);
    AddCommandListener(OnPlayerSay, "say");
    AddCommandListener(OnPlayerSay, "say_team");
}

public Action TextMsg(UserMsg msg_id, BfRead msg, const int[] players, int playersNum, bool reliable, bool init) {
    char Text[64];
    PbReadString(msg, "params", Text, sizeof(Text), 0);
    if(StrContains(Text, "teammate_attack") != -1 && GetConVarBool(g_bIgnoreFFMessage)) {
        return Plugin_Handled;
    }
    if(StrContains(Text, "Chat_SavePlayer", false) != -1 && GetConVarBool(g_bIgnoreSaveMessage)) {
        return Plugin_Handled;
    }
    if(StrContains(Text, "Cstrike_game_join", false) != -1 && GetConVarBool(g_bIgnoreJoinMessage)) {
        return Plugin_Handled;
    }
    
    return Plugin_Continue;
} 

public Action OnPlayerSay(int client, const char[] command,int argc) {
    char buff[2];
    GetCmdArg(1, buff, sizeof(buff));
    if(StrEqual(buff[0], "/") && GetConVarBool(g_bIgnoreSlash)) {
        return Plugin_Handled;
    }
    
    return Plugin_Continue;
}