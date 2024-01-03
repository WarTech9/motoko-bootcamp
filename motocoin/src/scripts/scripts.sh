#!/bin/bash

dfx canister call motocoin_backend mint "(
    record {
        owner = principal \"gd47d-uhrtw-h32zm-vlsdi-6ydpa-627py-ge6sj-l6srf-6fo7o-alvbs-tqe\";
    },
    1000)
"

dfx canister call motocoin_backend mint '(
    record {
        owner = principal "gd47d-uhrtw-h32zm-vlsdi-6ydpa-627py-ge6sj-l6srf-6fo7o-alvbs-tqe";
    },
    1000)
'

dfx canister call motocoin_backend transfer '(
    record {
        owner = principal "27nwx-ynx6s-2gclv-avhwf-aa5na-huqcs-77p4o-wosmw-cnj4m-cszki-kae"
    },
    25
)'

dfx canister call motocoin_backend balanceOf '(
    record {
        owner = principal "27nwx-ynx6s-2gclv-avhwf-aa5na-huqcs-77p4o-wosmw-cnj4m-cszki-kae"
    }
)'

dfx canister call motocoin_backend balanceOf '(
    record {
        owner = principal "gd47d-uhrtw-h32zm-vlsdi-6ydpa-627py-ge6sj-l6srf-6fo7o-alvbs-tqe"
    }
)'
