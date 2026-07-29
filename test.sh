#!/bin/bash
echo "Running LoveZero test suite using luajit..."
luajit tests/test_lovezero.lua

echo ""
echo "Running LoveZero screen tests..."
luajit tests/test_screen.lua

# If love is installed, users could optionally run tests headlessly via love if they add a love conf.lua hook, but standard lua works best for headless pure math testing.
# love . test
