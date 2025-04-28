/////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Audiokinetic Wwise generated include file. Do not edit.
//
/////////////////////////////////////////////////////////////////////////////////////////////////////

#ifndef __WWISE_IDS_H__
#define __WWISE_IDS_H__

#include <AK/SoundEngine/Common/AkTypes.h>

namespace AK
{
    namespace EVENTS
    {
        static const AkUniqueID ALIVE = 655265632U;
        static const AkUniqueID APPLE_HEAL = 22977312U;
        static const AkUniqueID BOSS = 1560169506U;
        static const AkUniqueID BOSS_DEATH = 4052139381U;
        static const AkUniqueID CHEST_OPEN = 2728948375U;
        static const AkUniqueID DEAD = 2044049779U;
        static const AkUniqueID FIREBALL = 3841200954U;
        static const AkUniqueID FOOTSTEP_HARDGROUND = 1829833920U;
        static const AkUniqueID FOOTSTEP_SOFTGROUND = 2411697751U;
        static const AkUniqueID GAMEPLAY = 89505537U;
        static const AkUniqueID GAMESTART_MENU = 4057560717U;
        static const AkUniqueID ITEM_ATTAIN = 2239953404U;
        static const AkUniqueID JOTUNHEIM = 117665206U;
        static const AkUniqueID KEY_ATTAIN = 3520404594U;
        static const AkUniqueID LIGHTNING_ATTACK = 3700812936U;
        static const AkUniqueID MAP_LOADED = 1758594367U;
        static const AkUniqueID MIDGARD = 2538683795U;
        static const AkUniqueID NEXT_DIALOUGE = 3599715827U;
        static const AkUniqueID PLAYER_HIT = 871813740U;
        static const AkUniqueID SKELETON_DEATH = 2670662143U;
        static const AkUniqueID SKELETON_HIT = 466730574U;
        static const AkUniqueID SNAKE_BITE = 1515870860U;
        static const AkUniqueID SNAKE_ROAR = 2475210562U;
        static const AkUniqueID SNAKE_SPIT = 4030153040U;
        static const AkUniqueID SPAWN = 71202558U;
        static const AkUniqueID SWORD_ATTACK_PC = 966589581U;
        static const AkUniqueID SWORD_SWING = 476098351U;
        static const AkUniqueID TITLE = 3705726509U;
        static const AkUniqueID VALHALLA = 3702692096U;
        static const AkUniqueID WITCH_DEATH = 1236609885U;
        static const AkUniqueID WITCH_LAUGH = 2152158020U;
    } // namespace EVENTS

    namespace STATES
    {
        namespace LOCATION
        {
            static const AkUniqueID GROUP = 1176052424U;

            namespace STATE
            {
                static const AkUniqueID BOSS_ARENA = 4129822198U;
                static const AkUniqueID JOTUNHEIM = 117665206U;
                static const AkUniqueID MIDGARD = 2538683795U;
                static const AkUniqueID NONE = 748895195U;
                static const AkUniqueID VALHALLA = 3702692096U;
            } // namespace STATE
        } // namespace LOCATION

        namespace PLAYERLIFE
        {
            static const AkUniqueID GROUP = 444815956U;

            namespace STATE
            {
                static const AkUniqueID ALIVE = 655265632U;
                static const AkUniqueID DEAD = 2044049779U;
                static const AkUniqueID NONE = 748895195U;
            } // namespace STATE
        } // namespace PLAYERLIFE

        namespace PLAYERSTATE
        {
            static const AkUniqueID GROUP = 3285234865U;

            namespace STATE
            {
                static const AkUniqueID BOSS = 1560169506U;
                static const AkUniqueID GAMEPLAY = 89505537U;
                static const AkUniqueID NONE = 748895195U;
                static const AkUniqueID PREBOSS = 2600172515U;
                static const AkUniqueID STORY = 1686739444U;
                static const AkUniqueID TITLE = 3705726509U;
                static const AkUniqueID VICTORY = 2716678721U;
            } // namespace STATE
        } // namespace PLAYERSTATE

    } // namespace STATES

    namespace SWITCHES
    {
        namespace BOSS_DEFEAT_COUNT
        {
            static const AkUniqueID GROUP = 1984334996U;

            namespace SWITCH
            {
            } // namespace SWITCH
        } // namespace BOSS_DEFEAT_COUNT

        namespace GAMEPLAY
        {
            static const AkUniqueID GROUP = 89505537U;

            namespace SWITCH
            {
                static const AkUniqueID CLEAR = 1754255536U;
                static const AkUniqueID COMBAT = 2764240573U;
                static const AkUniqueID EXPLORE = 579523862U;
            } // namespace SWITCH
        } // namespace GAMEPLAY

    } // namespace SWITCHES

    namespace GAME_PARAMETERS
    {
        static const AkUniqueID SIDECHAIN = 1883033791U;
        static const AkUniqueID SS_AIR_FEAR = 1351367891U;
        static const AkUniqueID SS_AIR_FREEFALL = 3002758120U;
        static const AkUniqueID SS_AIR_FURY = 1029930033U;
        static const AkUniqueID SS_AIR_MONTH = 2648548617U;
        static const AkUniqueID SS_AIR_PRESENCE = 3847924954U;
        static const AkUniqueID SS_AIR_RPM = 822163944U;
        static const AkUniqueID SS_AIR_SIZE = 3074696722U;
        static const AkUniqueID SS_AIR_STORM = 3715662592U;
        static const AkUniqueID SS_AIR_TIMEOFDAY = 3203397129U;
        static const AkUniqueID SS_AIR_TURBULENCE = 4160247818U;
    } // namespace GAME_PARAMETERS

    namespace BANKS
    {
        static const AkUniqueID INIT = 1355168291U;
        static const AkUniqueID MUSIC_SFX = 2901481334U;
    } // namespace BANKS

    namespace BUSSES
    {
        static const AkUniqueID MASTER_AUDIO_BUS = 3803692087U;
        static const AkUniqueID MUSIC_MIXER = 752057341U;
        static const AkUniqueID SFX_MIXER = 2790597333U;
    } // namespace BUSSES

    namespace AUDIO_DEVICES
    {
        static const AkUniqueID NO_OUTPUT = 2317455096U;
        static const AkUniqueID SYSTEM = 3859886410U;
    } // namespace AUDIO_DEVICES

}// namespace AK

#endif // __WWISE_IDS_H__
