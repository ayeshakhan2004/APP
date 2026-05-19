-- CIRO Database Schema
-- Supabase PostgreSQL Migration
-- Enable extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Signal sources table
CREATE TABLE signals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    source TEXT NOT NULL CHECK (source IN ('social_media','weather','traffic','emergency_calls','iot_sensor','field_report')),
    raw_data JSONB NOT NULL,
    location JSONB,
    credibility_score FLOAT DEFAULT 0.5 CHECK (credibility_score >= 0 AND credibility_score <= 1),
    urgency_score FLOAT DEFAULT 0.5,
    contradiction_level FLOAT DEFAULT 0.0,
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Crisis events table
CREATE TABLE crises (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    type TEXT NOT NULL CHECK (type IN ('flood','heatwave','accident','infrastructure','power_outage','protest','disease')),
    location JSONB NOT NULL,
    severity TEXT NOT NULL CHECK (severity IN ('critical','high','moderate','low')),
    confidence_score FLOAT CHECK (confidence_score >= 0 AND confidence_score <= 1),
    affected_population INT DEFAULT 0,
    expected_duration_hours FLOAT DEFAULT 1.0,
    peak_impact_time TIMESTAMPTZ,
    spread_risk TEXT DEFAULT 'low',
    status TEXT DEFAULT 'active' CHECK (status IN ('active','monitoring','resolved','retracted')),
    signal_ids UUID[] DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Resources table
CREATE TABLE resources (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    type TEXT NOT NULL CHECK (type IN ('ambulance','police_unit','rescue_team','shelter','generator','water_tanker','drone','field_team')),
    status TEXT DEFAULT 'available' CHECK (status IN ('available','deployed','returning')),
    current_lat FLOAT DEFAULT 33.6844,
    current_lng FLOAT DEFAULT 73.0479,
    assigned_crisis_id UUID REFERENCES crises(id),
    eta_minutes INT,
    base_name TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Allocations table
CREATE TABLE allocations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    crisis_id UUID REFERENCES crises(id) NOT NULL,
    resource_id UUID REFERENCES resources(id) NOT NULL,
    action TEXT NOT NULL,
    priority_score FLOAT,
    before_state JSONB,
    after_state JSONB,
    side_effects JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Stakeholder notifications
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    crisis_id UUID REFERENCES crises(id) NOT NULL,
    audience TEXT NOT NULL,
    message TEXT NOT NULL,
    channel TEXT DEFAULT 'app',
    sent_at TIMESTAMPTZ DEFAULT NOW()
);

-- Antigravity traces
CREATE TABLE traces (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_name TEXT NOT NULL,
    trace_type TEXT NOT NULL CHECK (trace_type IN ('observation','reasoning','decision','tool_call','action','error_recovery')),
    input_data JSONB DEFAULT '{}',
    output_data JSONB DEFAULT '{}',
    confidence FLOAT,
    latency_ms INT,
    reasoning_chain TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_signals_source ON signals(source);
CREATE INDEX idx_crises_status ON crises(status);
CREATE INDEX idx_crises_type ON crises(type);
CREATE INDEX idx_resources_status ON resources(status);
CREATE INDEX idx_traces_agent ON traces(agent_name);
CREATE INDEX idx_traces_type ON traces(trace_type);

-- Enable Realtime for key tables
ALTER PUBLICATION supabase_realtime ADD TABLE crises;
ALTER PUBLICATION supabase_realtime ADD TABLE resources;
ALTER PUBLICATION supabase_realtime ADD TABLE notifications;
ALTER PUBLICATION supabase_realtime ADD TABLE traces;
