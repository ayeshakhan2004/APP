# CIRO System Architecture

```mermaid
graph TD
    subgraph "Signal Sources"
        S1[Social Media]
        S2[Weather API]
        S3[Traffic Maps]
        S4[Emergency Calls]
        S5[IoT Sensors]
    end

    subgraph "Backend Orchestration (Antigravity)"
        ORCH[CIRO Orchestrator]
        A1[Signal Fusion Agent]
        A2[Crisis Detector Agent]
        A3[Severity Predictor]
        A4[Resource Allocator]
        A5[Action Simulator]
        A6[Stakeholder Notifier]
        A7[Recovery Agent]
    end

    subgraph "Persistence & Realtime"
        DB[(Supabase PostgreSQL)]
        RT[Realtime Subscriptions]
    end

    subgraph "Frontend"
        APP[Flutter Mobile App]
    end

    S1 & S2 & S3 & S4 & S5 --> ORCH
    ORCH --> A1 --> A2 --> A3 --> A4 --> A5 --> A6
    A2 -.-> A7
    
    A1 & A2 & A3 & A4 & A5 & A6 & A7 -- Traces --> DB
    A6 --> DB
    
    DB <--> RT <--> APP
    ORCH -- API --> APP
```

## Data Flow
1. **Ingestion**: Raw signals from 5 sources are fetched.
2. **Analysis**: 7 AI Agents (powered by Gemini 2.0) process the signals.
3. **Storage**: All decisions, predictions, and traces are saved to Supabase.
4. **Visualization**: Flutter app listens for real-time updates and displays them on the map and dashboard.
