#!/bin/bash

dfx canister call verifier addMyProfile '(
    record {
        name = "Joe Blow";
        team = "Legitters";
        graduate = false;
    }
)
'

dfx canister call verifier addMyProfile --identity alice '(
    record {
        name = "Alice In Wonderland";
        team = "Wonder Women";
        graduate = false;
    }
)
'

dfx canister call verifier updateMyProfile '(
    record {
        name = "Johnny Devs";
        team = "Legitters";
        graduate = false;
    }
)'

dfx canister call verifier addMyProfile --identity bob '(
    record {
        name = "Bobby Bravo";
        team = "Legitters";
        graduate = false;
    }
)
'

dfx canister call verifier getAllProfiles

dfx canister call verifier getProfilesOnTeam '("Legitters")'
