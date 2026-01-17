# WebSetup Automation Script (React + Vite / Simple Frontend)

This project contains a Bash script that automates **local deployment** of a web project on **Linux (Ubuntu/Debian based distros)** using **Nginx**.

It supports:
- ✅ **Simple Frontend projects** (HTML/CSS/JS)
- ✅ **React + Vite projects** (builds and deploys `dist/`)

---

## Features

- Clones a GitHub repository automatically (if not already present)
- Installs required services:
  - `nginx`
  - `nodejs` (via **nvm**)
- Detects if the project is **React + Vite** (by checking `package.json`)
- For React + Vite:
  - Runs `npm install`
  - Forces `base: '/'` in `vite.config.js`
  - Runs `npm run build`
  - Deploys `dist/` using Nginx
- For simple frontend:
  - Deploys the repository directly using Nginx
- Creates and enables an Nginx site config automatically
- Stores deployment info in an environment file

---

## Requirements

Your system should have:
- Ubuntu / Debian based Linux distro
- `sudo` privileges
- Internet connection
- `git` installed
- `curl` installed

---
#Run the script

./websetup/automated.sh

---
##Troubleshooting:

  - issue: "404 Not Found"
    possible_causes:
      - "Nginx is not running"
      - "Wrong Nginx root path"
      - "Site configuration is not enabled"
      - "Project files were not copied to the expected location"
    resolution:
      - "Confirm the correct Nginx site is enabled"
      - "Confirm the root directory contains index.html"
      - "Reload Nginx after configuration changes"

  - issue: "MIME type error (JS/CSS served as text/html) in React + Vite"
    possible_causes:
      - "Vite base path is incorrect (example: /To-Do-List/ instead of /)"
      - "Assets are being requested from the wrong URL prefix"
      - "Nginx is falling back to index.html for missing asset files"
    resolution:
      - "Ensure Vite base is set to '/' when serving from the domain root"
      - "Rebuild the project after changing the base"
      - "Verify dist/index.html contains /assets/... paths (not /project-name/assets/...)"

  - issue: "Permission denied (13) in Nginx logs"
    possible_causes:
      - "Nginx does not have access to the project directory"
      - "Incorrect ownership or permissions on deployed files"
    resolution:
      - "Ensure the deployed directory is readable by the Nginx user"
      - "Prefer deploying under standard web directories instead of user home folders"

  - issue: "Site works on localhost but not on IP address"
    possible_causes:
      - "Wrong server block is being matched"
      - "Multiple Nginx site configurations conflict"
    resolution:
      - "Ensure the correct site is set as the default server"
      - "Disable unused site configurations to avoid conflicts"

  - issue: "Changes are not reflected in the browser"
    possible_causes:
      - "Old build is still deployed"
      - "Browser cache is serving outdated files"
    resolution:
      - "Rebuild and redeploy the project"
      - "Hard refresh the browser or clear site cache"

---
##Logs

- Logs are written to /websetup/logs/error.log
---

##Notes
- This script is intended for local setup and learning purposes.
- For React + Vite projects, it automatically forces: base:'/' to avoid incorrect asset paths during Nginx deployment.
---
##License
- This project is for educational use.

