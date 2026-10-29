# Panopticon Sentinel UI — Enterprise EDR Web Console

[![Organization](https://img.shields.io/badge/Org-Panopticon--Co-blue.svg)](https://github.com/Panopticon-Co)
[![Author](https://img.shields.io/badge/Author-Aditya%20Singh%20(K064)-darkgreen.svg)](https://github.com/Adityasingh230058)
[![Role](https://img.shields.io/badge/Role-Lead%20Detection%20%26%20Dashboard%20Architect-purple.svg)]()
[![Status](https://img.shields.io/badge/Build-Passing-brightgreen.svg)]()
[![Unit Tests](https://img.shields.io/badge/Unit%20Tests-64%2F64%20Passing-success.svg)]()
[![E2E Tests](https://img.shields.io/badge/E2E%20Tests-49%2F49%20Passing-success.svg)]()
[![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)](LICENSE)

> **Dedicated Frontend-Only Repository for the Panopticon EDR / XDR Platform**  
> Architected, developed, and maintained by **Aditya Singh** (Lead Detection & Dashboard Architect, Roll: K064).  
> For the comprehensive full-stack capstone demonstration (including the Spring Boot Java telemetry backend), see [Panopticon-Co/panopticon-edr-dashboard](https://github.com/Panopticon-Co/panopticon-edr-dashboard).

---

## 1. Executive Summary

**Panopticon Sentinel UI** is a SentinelOne-inspired security operations console for the Panopticon EDR/XDR platform. It delivers real-time threat visualization, endpoint investigation, and active incident response execution across Linux and Windows fleets.

This repository represents the official **frontend-only extraction** of Aditya Singh's latest verified dashboard architecture, ensuring clean separation of concerns from teammate repositories (such as Rishi Bose's evidence verification console in `panopticon-console`) while maintaining strict 1:1 API contract parity with `panopticon-manager` and `panopticon-response-engine`.

---

## 2. Key Architectural Features

### 🛡️ SentinelOne-Inspired 4-Slide Navigation Engine
Eliminated disjointed multi-page reloads in favor of a responsive 4-slide single-page dashboard architecture:
1. **Slide 1 — `#overview`**: High-level fleet telemetry overview, active incident counters, threat severity distributions, and quick triage status.
2. **Slide 2 — `#endpoints`**: Real-time managed agent roster, host telemetry health, network isolation toggles, and OS breakdown (Windows ETW/Sysmon & Linux procfs).
3. **Slide 3 — `#alerts`**: Paginated detection alerts stream, MITRE ATT&CK technique mapping, raw evidence inspection, and client-side filtering/search.
4. **Slide 4 — `#response`**: Closed 7-action response execution queue with state lifecycle monitoring and audit logging.

### 🚫 Decommission of Obsolete Multi-Cycle Lake
Per enterprise security review, the legacy, unanchored **"Fleet Telemetry Fluctuations // Multi-Cycle Lake"** telemetry section has been completely decommissioned. Zero orphaned DOM nodes, simulated SVG cycles, or unverified endpoints remain.

### ⚡ Closed 7-Action Response Vocabulary Integration
Fully implements Panopticon's closed 7-action response vocabulary defined by `panopticon-response-engine`:
- **Auto-Safe Tier** *(Instant dispatch)*:
  - `COLLECT_PROCESS_INFO`
  - `COLLECT_NETWORK_CONNECTIONS`
- **Analyst-Approval Tier** *(Protected by confirmation modal & justification prompt)*:
  - `KILL_PROCESS` (Destructive)
  - `COLLECT_FILE`
  - `QUARANTINE_FILE`
  - `ISOLATE_HOST` (Destructive)
  - `RELEASE_HOST_ISOLATION` (Destructive)

### 🔒 Secure Manager API Proxy with Bearer Token Encapsulation
The Python backend console server (`app.py`) operates as a secure reverse proxy:
- **Zero Token Leakage**: The `PANOPTICON_MANAGER_TOKEN` is injected server-side into upstream calls to `panopticon-manager`. Bearer tokens are never exposed to client-side JavaScript or DOM attributes.
- **Strict Input Validation**: Rejects empty justification reasons with HTTP 400, enforces a 16KB payload limit (HTTP 413), and isolates unreachable Manager failures with HTTP 502/503.
- **Dual Runtime Operational Modes**:
  - **Standalone File Mode**: Runs zero-config from `alerts.ndjson` for offline threat simulations and isolated demonstrations.
  - **Live Manager Proxy Mode**: Streams real-time alerts and response actions directly from `panopticon-manager`.

### 🎨 Dual-Theme Design Tokens & Accessibility
- Complete design token architecture (`tokens.css`, `layout.css`) supporting Cyberpunk Dark Mode and High-Contrast Light Mode.
- Full WCAG 2.2 AA color contrast compliance across all badges, status indicators, and modal overlays.

---

## 3. Repository Structure

```
panopticon-sentinel-ui-aditya/
├── app.py                      # Standalone or Proxied Python Web Console server
├── alerts.ndjson               # Local golden telemetry alert fixtures (offline mode)
├── start_console.bat           # 1-click Windows startup script
├── static/
│   ├── index.html              # SentinelOne-inspired 4-slide single-page application
│   ├── app.js                  # Frontend logic & state management (zero build step)
│   └── css/
│       ├── tokens.css          # Design tokens (dark/light, accessible contrast)
│       └── layout.css          # Layout styles & slide navigation transitions
├── docs/
│   ├── PANOPTICON_V1.md        # Technical specification & UI architecture
│   └── screenshots/            # Verification screenshots (overview, alerts, response)
└── tests/
    ├── __init__.py
    ├── fake_manager.py         # Mock Manager backend for offline proxy testing
    ├── test_http.py            # HTTP routing and header security tests
    ├── test_read_alerts.py     # Local file parser tests
    ├── test_manager_proxy.py   # Manager proxy routing & dual-format parsing tests
    ├── test_response_actions_proxy.py # Closed 7-action proxy tests
    ├── test_response_proxy_adversarial.py # Adversarial security tests (input sanitization)
    └── e2e/                    # Complete 49-case End-to-End Test Suite
        ├── config.js           # Test configuration & port mappings
        ├── runner.js           # Node.js automated test runner
        ├── runner.py           # Cross-platform runner wrapper
        ├── helpers/            # Mock server & assertion helpers
        ├── tier1_features/     # R1 Lake Decommission, R2 Response, R3 Slides
        ├── tier2_boundaries/   # Boundary conditions & error states
        ├── tier3_combinations/ # Pairwise state & theme interactions
        └── tier4_real_world/   # Full analyst workflow simulations
```

---

## 4. Quickstart Guide

### Prerequisites
- Python 3.10+ (Standard library only; zero pip dependencies required)
- Node.js 18+ (Required only for running the E2E test suite)

### Option A: Standalone Mode (Zero Dependencies)
Run the console using local offline alert fixtures:
```bash
python app.py --port 8787 --alerts-file alerts.ndjson
```
Open your browser to: **`http://127.0.0.1:8787/#overview`**

### Option B: Live Manager Proxy Mode
Connect the console to an upstream Panopticon Manager or Spring Boot Backend:
```bash
# Set your analyst authorization token
export PANOPTICON_MANAGER_TOKEN="your-analyst-token"

# Launch console proxying to Manager on port 8788
python app.py --port 8787 --manager-url http://127.0.0.1:8788
```

---

## 5. Automated Verification & Test Results

The console is backed by a dual-tier testing infrastructure achieving **100% test pass rate**:

### 1. Python Unit & Security Suite (64/64 PASS)
Tests HTTP routing, Manager proxying, response validation, adversarial inputs, and token protection:
```bash
python -m unittest discover -s tests -v
```
```
Ran 64 tests in 27.549s
OK
```

### 2. Node.js E2E Test Suite (49/49 PASS)
Simulates browser DOM interactions, slide routing, destructive action confirmations, and API contracts:
```bash
node tests/e2e/runner.js
```
```
======================================================================
PANOPTICON EDR DASHBOARD — E2E TEST SUITE RUNNER
Mode: Target Tier = ALL
======================================================================
Running [tier1_features\test_r1_lake_decommission.test.js] ... PASS (6/6)
Running [tier1_features\test_r2_response_engine.test.js] ... PASS (7/7)
Running [tier1_features\test_r3_slide_navigation.test.js] ... PASS (6/6)
Running [tier2_boundaries\test_r1_lake_boundaries.test.js] ... PASS (6/6)
Running [tier2_boundaries\test_r2_response_boundaries.test.js] ... PASS (8/8)
Running [tier2_boundaries\test_r3_slide_boundaries.test.js] ... PASS (6/6)
Running [tier3_combinations\test_pairwise_interactions.test.js] ... PASS (6/6)
Running [tier4_real_world\test_analyst_workflows.test.js] ... PASS (4/4)
----------------------------------------------------------------------
Total Test Cases: 49 | Passed: 49 | Failed: 0 | Pass Rate: 100.0%
======================================================================
```

---

## 6. Team Attribution & Ownership

| Contributor | Role & Domain | Primary Repository |
| :--- | :--- | :--- |
| **Aditya Singh** (`Adityasingh230058`) | **Lead Detection & Dashboard Architect (Roll: K064)**<br>Sentinel UI, Slide Navigation, Response Queue, Proxy Layer | **`Panopticon-Co/panopticon-sentinel-ui-aditya`** *(Frontend)*<br>**`Panopticon-Co/panopticon-edr-dashboard`** *(Full-Stack)* |
| **Rishi Bose** (`rishibose35`) | **Evidence & Verification Lead**<br>Artifact Verification, Signed Telemetry Downloads | **`Panopticon-Co/panopticon-console`** |

---

## 7. License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
