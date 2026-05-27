#!/usr/bin/bash

cargo build --release
sudo cp target/release/sigwm /usr/bin/sigwm