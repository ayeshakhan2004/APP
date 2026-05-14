"""Base agent class for all CIRO agents."""

from abc import ABC, abstractmethod
from typing import Any, Dict
from ..utils.trace_logger import trace_logger


class BaseAgent(ABC):
    """Base class for all CIRO agents. Each agent logs traces automatically."""

    def __init__(self, name: str):
        self.name = name
        self.logger = trace_logger

    @abstractmethod
    async def execute(self, input_data: Dict[str, Any]) -> Dict[str, Any]:
        """Execute the agent's primary task."""
        pass

    async def run(self, input_data: Dict[str, Any]) -> Dict[str, Any]:
        """Run with automatic trace logging."""
        import time
        self.logger.log_observation(self.name, {"input": str(input_data)[:200]}, 1.0)
        start = time.time()
        try:
            result = await self.execute(input_data)
            latency = int((time.time() - start) * 1000)
            self.logger.log_action(self.name, "execute", input_data, result)
            return result
        except Exception as e:
            self.logger.log_error_recovery(self.name, str(e), "manual_escalation", {"status": "failed"})
            raise
