{ config, lib, ... }:

let
  inherit (lib)
    mkIf
    ;

  vesktop = config.programs.vesktop;
in
{
  config = mkIf vesktop.enable {
    programs.vesktop = {
      enabledPlugins = [
        ### Required (Always Enabled) ###
        "NoTrack"
        "SupportHelper"
        ### User Plugins ###
        "AlwaysAnimate"
        "AutomodContext"
        "FriendsSince"
        "ValidReply"
      ];

      plugins = {
        ### Required (Always Enabled) ###
        Settings = {
          enable = true;
          settings = { settingsLocation = "aboveNitro"; };
        };

        WebContextMenus = {
          enable = true;
          settings = { addBack = true; };
        };

        ### User Plugins ###
        AlwaysAnimate.enable = true;
        AlwaysTrust.enable = false;
        AnonymiseFileNames.enable = false;
        BANger = {
          enable = false;
          settings = {
            source = ""; # imgur link
          };
        };
        BetterFolders = {
          # Ugly as shit imo
          enable = false;
          settings = {
            closeAllFolders = false;
            closeOthers = false;
            forceOpen = false;
            sidebar = true;
            sidebarAnim = true;
            showFolderIcon = 1;
            closeAllHomeButton = false;
            keepIcons = true;
          };
        };
        BetterGifAltText.enable = true;
        BetterGifPicker.enable = true;
        BetterNotesBox = {
          enable = false;
          settings = {
            hide = false;
            noSpellCheck = false;
          };
        };
        BetterRoleContext.enable = false;
        BetterRoleDot = {
          enable = false;
          settings = {
            bothStyles = false;
            copyRoleColorInProfilePopout = false;
          };
        };
        BetterUploadButton.enable = true;
        BiggerStreamPreview.enable = false;
        BlurNSFW = {
          enable = true;
          settings = {
            blurAmount = 10;
          };
        };
        CallTimer = {
          enable = true;
          settings = {
            format = "stopwatch";
          };
        };
        ClearURLs.enable = true;
        ClientTheme = {
          enable = false;
          settings = {
            color = 313338;
          };
        };
        ColorSighted.enable = false;
        ConsoleShortcuts.enable = false;
        CopyUserURLs.enable = true;
        CrashHandler = {
          enable = true;
          settings = {
            attemptToPreventCrashes = true;
            attemptToNavigateToHome = false;
          };
        };
        CustomRPC = {
          enable = false;
          settings = {
            type = 0;
            timestampMode = 0;
          };
        };
        Dearrow.enable = false;
        Decor.enable = false;
        DisableCallIdle.enable = false;
        EmoteCloner.enable = true;
        Experiments = {
          enable = false;
          settings = {
            enableIsStaff = false;
          };
        };
        F8Break.enable = false;
        FakeNitro = {
          enable = true;
          settings = {
            enableEmojiBypass = true;
            emojiSize = 48;
            transformEmojis = true;
            enableStickerBypass = true;
            stickerSize = 160;
            transformStickers = true;
            transformCompoundSentence = true;
            enableStreamQualityBypass = false;
            useHyperLinks = true;
          };
        };
        FakeProfileThemes = {
          enable = false;
          settings = {
            nitroFirst = true;
          };
        };
        FavoriteEmojiFirst.enable = true;
        FavoriteGifSearch = {
          enable = true;
          settings = {
            searchOption = "hostandpath";
          };
        };
        FixCodeblockGap.enable = false;
        FixSpotifyEmbeds.enable = false;
        FixYoutubeEmbeds.enable = true;
        ForceOwnerCrown.enable = true;
        FriendInvites.enable = true;
        FriendsSince.enable = true;
        GameActivityToggle = {
          enable = false;
          settings = {
            oldIcon = false;
          };
        };
        GifPaste.enable = true;
        GreetStickerPicker.enable = true;
        HideAttachments.enable = false;
        iLoveSpam.enable = true;
        IgnoreActivities.enable = false;
        ImageZoom = {
          enable = true;
          settings = {
            saveZoomValues = false;
            #preventCarouselFromClosingOnClick = true;
            invertScroll = true;
            nearestNeigherbour = false;
            square = false;
            zoom = 2.00;
            size = 200.00;
            zoomSpeed = 0.50;
          };
        };
        InvisibleChat = {
          enable = false;
          settings = {
            savedPasswords = "password, Password";
          };
        };
        KeepCurrentChannel.enable = false;
        LastFMRichPresence = {
          enable = true;
          settings = {
            username = "";
            apiKey = "";
            shareUsername = false;
            hideWithSpotify = false;
            statusName = "some music";
            nameFormat = "artist-first";
            useListeningStatus = true;
            missingArt = "lastfmLogo";
          };
        };
        LoadingQuotes = {
          enable = false;
          settings = { replaceEvents = false; };
        };
        MemberCount.enable = true;
        MessageClickActions = {
          enable = true;
          settings = {
            enableDeleteOnClick = true;
            enableDoubleClickToEdit = true;
            enableDoubleClickToReply = true;
            requireModifier = false;
          };
        };
        MessageLinkEmbeds = {
          enable = true;
          settings = {
            automodEmbeds = "never";
            listMode = "blacklist";
            idList = "";
          };
        };
        MessageLogger = {
          enable = true;
          settings = {
            deleteStyle = "text";
            ignoreBots = "false";
            ignoreSelf = "true";
            ignoreUsers = "";
            ignoreChannels = "";
            ignoreGuilds = "";
          };
        };
        MessageTags = {
          enable = false;
          settings = { clyde = true; };
        };
        MoreCommands.enable = true;
        MoreKaomoji.enable = false;
        MoreUserTags = {
          enable = true;
          settings = {
            dontShowForBots = false;
            dontShowBotTag = false;
            tagSettings = {
              WEBHOOK = {
                text = "Webhook";
                showInChat = true;
                showInNotChat = true;
              };
              OWNER = {
                text = "Owner";
                showInChat = true;
                showInNotChat = true;
              };
              ADMINISTRATOR = {
                text = "Admin";
                showInChat = true;
                showInNotChat = true;
              };
              MODERATOR_STAFF = {
                text = "Staff";
                showInChat = true;
                showInNotChat = true;
              };
              MODERATOR = {
                text = "Mod";
                showInChat = true;
                showInNotChat = true;
              };
              VOICE_MODERATOR = {
                text = "VC Mod";
                showInChat = true;
                showInNotChat = true;
              };
            };
          };
        };
        Moyai = {
          enable = true;
          settings = {
            ignoreBots = true;
            ignoreBlocked = true;
            volume = 0.5;
            quality = "Normal";
            triggerWhenUnfocused = true;
          };
        };
        NewGuildSettings = {
          enable = true;
          settings = {
            guild = true;
            everyone = false;
            role = false;
            showAllChannels = true;
          };
        };
        MutualGroupDMs.enable = true;
        NoBlockedMessages = {
          enable = false;
          settings = { ignoreBlockedMessages = true; };
        };
        NoDevToolsWarning.enable = false;
        NoF1.enable = true;
        NoMosaic = {
          enable = true;
          settings = {
            inlineVideo = true;
            mediaLayoutType = "STATIC";
          };
        };
        NoPendingCount = {
          enable = true;
          settings = {
            hideFriendRequestCount = false;
            hideMessageRequestCount = false;
            hidePremiumOffersCount = true;
          };
        };
        NoProfileThemes.enable = false;
        NoReplyMention = {
          enable = false;
          settings = {
            userList = "1234567890123445,1234567890123445";
            shouldPingListed = true;
            inverseShiftReply = true;
          };
        };
        NoScreensharePreview.enable = false;
        NoTypingAnimation.enable = false;
        NoUnblockToJump.enable = true;
        NotificationVolume = {
          enable = false;
          settings = { notificationVolume = 100; };
        };
        NSFWGateBypass.enable = false;
        oneko.enable = false;
        OnePingPerDM = {
          enable = false;
          settings = {
            channelToAffect = "both_dms";
            allowMentions = false;
            allowEveryone = false;
          };
        };
        OpenInApp = {
          enable = true;
          settings = {
            spotify = false;
            steam = true;
            epic = false;
          };
        };
        PartyMode = {
          enable = false;
          settings = { superIntensePartyMode = 0; }; # 0-2
        };
        PermissionFreeWill = {
          enable = false;
          settings = {
            lockout = true;
            onboarding = true;
          };
        };
        PermissionsViewer = {
          enable = false;
          settings = {
            permissionsSortOrder = 0;
            defaultPermissionDropdownState = false;
          };
        };
        petpet.enable = false;
        PictureInPicture = {
          enable = false;
          settings = { loop = true; };
        };
        PinDMs = {
          enable = true;
          settings = {
            sortDmsByNewestMessage = true;
            dmSectioncollapsed = false;
            /* Outdated, Gotta Find What Black Magic PinDMs Uses Now
            pinnedDMs = "1160838589890961419,1201774443832295475,940715402294607902,1012431223861285025,917622324491087922,952361563912806451";
            */
          };
        };
        PlainFolderIcon.enable = false;
        PlatformIndicators = {
          enable = true;
          settings = {
            list = true;
            badges = true;
            messages = true;
            colorsMobileIndicator = true;
          };
        };
        PreviewMessage.enable = false;
        PronounDB = {
          enable = true;
          settings = {
            pronounsFormat = "CAPITALIZED";
            pronounSource = 0; # 0 = pronoundb first 1 = discord first
            showSelf = false;
            showInMessages = true;
            showInProfile = true;
          };
        };
        QuickMention.enable = false;
        QuickReply = {
          enable = true;
          settings = { shouldMention = 1; }; # 0 = Follow NoReplyMention 1 = True 2 = False
        };
        ReactErrorDecoder.enable = false;
        ReadAllNotificationsButton.enable = false;
        RelationshipNotifier = {
          enable = true;
          settings = {
            notices = true;
            offlineRemovals = true;
            friends = true;
            friendRequestCancels = true;
            servers = true;
            groups = true;
          };
        };
        ReplaceGoogleSearch = {
          enable = true;
          settings = {
            customEngineName = "Brave";
            customEngineURL = "https://search.brave.com/search?q=";
          };
        };
        ResurrectHome = {
          enable = false;
          settings = {
            forceServerHome = false;
          };
        };
        RevealAllSpoilers.enable = false;
        ReverseImageSearch.enable = true;
        ReviewDB = {
          # Might require re-authorization
          enable = true;
          settings = {
            notifyReviews = true;
            showWarning = true;
            hideTimestamps = false;
            hideBlockedUsers = false;
          };
        };
        RoleColorEverywhere = {
          enable = false;
          settings = {
            chatMentions = true;
            memberList = true;
            voiceUsers = true;
          };
        };
        SearchReply.enable = true;
        SecretRingToneEnabler.enable = false;
        SendTimestamps = {
          enable = true;
          settings = { replaceMessageContents = true; };
        };
        ServerListIndicators = {
          enable = true;
          settings = { mode = 3; }; # 1 = Server Count 2 = Online Friends 3 = Both
        };
        ServerProfile.enable = true;
        ShikiCodeblocks = {
          enable = true;
          settings = {
            theme = "https://raw.githubusercontent.com/shikijs/shiki/0b28ad8ccfbf2615f2d9d38ea8255416b8ac3043/packages/shiki/themes/dark-plus.json"; # dark-plus
            tryHljs = "SECONDARY";
            useDevIcon = "COLOR";
            bgOpacity = 100;
          };
        };
        ShowAllMessageButtons.enable = true;
        ShowConnections = {
          enable = true;
          settings = {
            iconSize = 32;
            iconSpacing = 1; # 0 = Compact 1 = Cozy 2 = Roomy
          };
        };
        ShowHiddenChannels = {
          enable = true;
          settings = {
            hideUnreads = true;
            showMode = 1; # 0 = Plain with Lock 1 = Muted with Eye
            defaultAllowedUsersAndRolesDropdownState = true;
          };
        };
        ShowMeYourName = {
          enable = true;
          settings = {
            mode = "nick-user";
            displayNames = false;
            inReplies = true;
          };
        };
        ShowTimeouts.enable = true;
        SilentMessageToggle = {
          enable = false;
          settings = {
            persistState = true;
            autoDisable = true;
          };
        };
        SilentTyping = {
          enable = false;
          settings = {
            showIcon = true;
            isEnabled = true;
          };
        };
        SortFriendRequests = {
          enable = true;
          settings = { showDates = true; };
        };
        SpotifyControls = {
          enable = false;
          settings = {
            hoverControls = true;
            useSpotifyUris = false;
          };
        };
        SpotifyCrack = {
          enable = false;
          settings = {
            noSpotifyAutoPause = true;
            keepSpotifyActivityOnIdle = true;
          };
        };
        SpotifyShareCommands.enable = false;
        StartupTimings.enable = true;
        SuperReactionTweaks = {
          enable = true;
          settings = {
            superReactByDefault = false;
            unlimitedSuperReactionPlaying = true;
            superReactionPlayingLimit = 20;
          };
        };
        TextReplace.enable = false;
        ThemeAttributes.enable = false;
        TimeBarAllActivities.enable = false;
        Translate = {
          enable = false;
          settings = { autoTranslate = false; };
        };
        TypingIndicator = {
          enable = true;
          settings = {
            includeCurrentChannel = true;
            includeMutedChannels = false;
            includeBlockedUsers = false;
          };
        };
        TypingTweaks = {
          enable = true;
          settings = {
            showAvatars = true;
            showRoleColors = false;
            alternativeFormatting = true;
          };
        };
        Unindent.enable = true;
        UnsuppressEmbeds.enable = true;
        UrbanDictionary.enable = false;
        UserVoiceShow = {
          enable = true;
          settings = {
            showInUserProfileModal = true;
            showVoiceChannelSectionHeader = true;
          };
        };
        USRBG = {
          enable = false;
          settings = {
            nitroFirst = true;
            voiceBackground = true;
          };
        };
        ValidUser.enable = true;
        VcNarrator.enable = false; # Cursed
        VencordToolbox.enable = true;
        ViewIcons = {
          enable = true;
          settings = {
            format = "png";
            imgSize = "1024";
          };
        };
        ViewRaw = {
          enable = true;
          settings = { clickMethod = "Right"; };
        };
        VoiceChatDoubleClick.enable = false;
        VoiceMessage = {
          enable = true;
          settings = {
            noiseSuppression = true;
            echoCancellation = true;
          };
        };
        WebKeybinds.enable = true;
        "WebRichPresence (arRPC)".enable = false;
        WhoReacted.enable = true;
        Wikisearch.enable = false;
        XSOverlay = {
          enable = false;
          settings = {
            ignoreBots = true;
            pingColor = "#7289da";
            channelPingColor = "#8a2be2";
            soundPath = "default";
            timeout = 1;
            opacity = 1;
            volume = 0.2;
          };
        };
      };
    };
  };
}
