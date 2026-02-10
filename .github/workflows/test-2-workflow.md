---
on:
  workflow_dispatch:

permissions:
  contents: read
  issues: read
  pull-requests: read

tools:
  github:
---

# Pipeline Failure Analysis Agentic Workflow

## Overview

- **Workflow Name:** Pipeline Failure Analysis and Intelligence
- **Purpose:** Automatically analyzes failed CI/CD pipelines, identifies root causes, and provides actionable insights and recommendations
- **Scope:** Triggers on workflow failures, performs intelligent analysis, and reports findings to pull requests and issues


## Components

### Agents

#### 1. Log Fetcher Agent
- **Role:** Collects and aggregates all relevant workflow execution data
- **Inputs:** 
  - Workflow run ID
  - GitHub API token
  - Repository context
- **Outputs:** 
  - Consolidated logs from all failed jobs
  - Job metadata and status information
  - Workflow artifacts
- **Triggers:** Workflow run completion event

#### 2. Pattern Analysis Agent
- **Role:** Identifies common failure patterns in logs using regex matching and heuristics
- **Inputs:** 
  - Consolidated workflow logs
  - Pattern definition database
- **Outputs:** 
  - Detected failure patterns with frequency counts
  - Pattern categorization (dependency, build, test, performance, security, resource, network)
  - Severity levels for each pattern
- **Triggers:** Log Fetcher Agent completion

#### 3. Root Cause Agent
- **Role:** Determines the most likely root cause of failure and provides confidence scoring
- **Inputs:** 
  - Detected failure patterns
  - Pattern frequencies and severities
- **Outputs:** 
  - Primary root cause determination
  - Confidence score (0-100%)
  - Secondary causes if applicable
- **Triggers:** Pattern Analysis Agent completion

#### 4. Insights Generator Agent
- **Role:** Generates context-specific recommendations and prevention strategies
- **Inputs:** 
  - Root cause determination
  - Pattern analysis results
  - Insights database
- **Outputs:** 
  - Actionable recommendations with priority levels
  - Prevention strategies
  - Related insights and explanations
- **Triggers:** Root Cause Agent completion

#### 5. Reporting Agent
- **Role:** Formats and delivers analysis results to appropriate GitHub locations
- **Inputs:** 
  - Complete analysis report
  - PR context (if applicable)
  - Issue context (if applicable)
- **Outputs:** 
  - PR comments with formatted report
  - GitHub issue creation (for recurring failures)
  - Artifact storage
- **Triggers:** Insights Generator Agent completion

### Other Components/Resources

- **GitHub Actions API:** Fetches workflow execution data
- **Pattern Database:** Stores regex patterns and failure categories
- **Insights Database:** Maps failure types to recommendations
- **GitHub REST API:** Posts results and manages issues

## Workflow Steps

### Step 1: Workflow Failure Detection
- **Description:** System detects a completed workflow run with a failure conclusion
- **Agent Involved:** GitHub Actions Trigger
- **Inputs:** 
  - Workflow run event from target CI/CD pipeline
  - Failure status confirmation
- **Outputs:** 
  - Trigger event passed to Log Fetcher Agent
  - Workflow context (ID, repository, branch)

### Step 2: Log Collection and Aggregation
- **Description:** Log Fetcher Agent retrieves all logs, artifacts, and metadata from the failed workflow
- **Agent Involved:** Log Fetcher Agent
- **Inputs:** 
  - Workflow ID
  - GitHub API token
  - Repository information
- **Outputs:** 
  - `workflow-logs.json` containing:
    - All job logs (stdout/stderr)
    - Failed job details
    - Workflow artifacts
    - Job timings and resource usage

### Step 3: Pattern Recognition and Analysis
- **Description:** Pattern Analysis Agent scans logs against failure pattern database
- **Agent Involved:** Pattern Analysis Agent
- **Inputs:** 
  - Raw workflow logs
  - Failure pattern definitions (7+ categories)
- **Outputs:** 
  - `failure-analysis.json` with:
    - Detected patterns and match counts
    - Pattern categories and severity levels
    - Confidence metrics

### Step 4: Root Cause Determination
- **Description:** Root Cause Agent analyzes detected patterns to determine primary failure cause
- **Agent Involved:** Root Cause Agent
- **Inputs:** 
  - Pattern analysis results
  - Severity and frequency scoring
- **Outputs:** 
  - Primary root cause identification
  - Confidence score (algorithm: pattern weight × frequency × severity)

### Step 5: Insights and Recommendations Generation
- **Description:** Insights Generator Agent creates actionable recommendations based on root cause
- **Agent Involved:** Insights Generator Agent
- **Inputs:** 
  - Root cause determination
  - Insights database
- **Outputs:** 
  - High-priority recommendations with details
  - Medium/Low-priority actions
  - Prevention strategies for future occurrences
  - Context-specific insights

### Step 6: Report Generation and Delivery
- **Description:** Reporting Agent formats comprehensive analysis and posts to relevant locations
- **Agent Involved:** Reporting Agent
- **Inputs:** 
  - Complete analysis report
  - GitHub context (PR number, issue number)
- **Outputs:** 
  - PR comment with formatted report (if PR-triggered)
  - GitHub issue creation (for recurring failures)
  - `failure-analysis-report.json` artifact

