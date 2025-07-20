# EasyHash MacOS

Simple scripts for generating and verifying SHA256 hashes in macOS folders.

## Scripts

### HASH GENERATOR - SHA256 (`GerarHash.command`)

This script generates a SHA256 hash file for all files in a selected folder.

**How to use:**
1. Double-click the `GerarHash.command` file.
2. Drag your folder into the terminal window and press Enter.
3. The script will generate a file named `<folder_name>_SHA256SUMS.txt` with the hashes of all files, and will also log the operation in `controle.txt`.

---

### INTEGRITY CHECKER - SHA256 (`VerificaHash.command`)

This script checks the integrity of the files in a folder by comparing the current hashes with those recorded in the previously generated hash file.

**How to use:**
1. Double-click the `VerificaHash.command` file.
2. Drag your folder into the terminal window and press Enter.
3. The script will look for the hash file (`*_SHA256SUMS.txt`), compare the hashes, and inform you if any file has been changed or is missing. The result is logged in `controle.txt`.

---

## Motivation

- I created this project to streamline the verification of audiovisual projects. I always generate the hash at the moment I back up the files.

---

## Notes

- Both scripts work only on macOS.
- The `controle.txt` file serves as a log of all operations performed.
- Make sure the scripts have execution permission (`chmod +x GerarHash.command VerificaHash.command`).
