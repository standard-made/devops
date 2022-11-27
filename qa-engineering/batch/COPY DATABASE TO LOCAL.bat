@echo off
Title COPY DATABASE TO LOCAL

del /q "E:\Users\<username>\DBs to Restore\*.*"

robocopy "\\rt-ops\public\FuelPurchaseOp_BAKs" "E:\Users\<username>\DBs to Restore" "*.bak"