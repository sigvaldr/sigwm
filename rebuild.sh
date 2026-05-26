#!/usr/bin/bash

cargo build --release
sudo cp target/release/sigwm /bin/sigwm
