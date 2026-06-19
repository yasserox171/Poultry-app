import { useState, useEffect, useRef } from 'react';
import { MOCK_ENVIRONMENT } from '../data/mockData';

interface LiveSensorData {
  temperature: number;
  humidity: number;
  co2: number;
  ventilation: number;
  tempHistory: number[];
  humidityHistory: number[];
  isLive: boolean;
}

function clamp(val: number, min: number, max: number) {
  return Math.min(Math.max(val, min), max);
}

function randomDelta(range: number) {
  return (Math.random() - 0.5) * 2 * range;
}

export function useLiveData(enabled = true): LiveSensorData {
  const [data, setData] = useState<LiveSensorData>({
    temperature: MOCK_ENVIRONMENT.temperature,
    humidity: MOCK_ENVIRONMENT.humidity,
    co2: MOCK_ENVIRONMENT.co2,
    ventilation: MOCK_ENVIRONMENT.ventilation,
    tempHistory: [...MOCK_ENVIRONMENT.tempHistory],
    humidityHistory: [...MOCK_ENVIRONMENT.humidityHistory],
    isLive: true,
  });

  const intervalRef = useRef<ReturnType<typeof setInterval> | null>(null);

  useEffect(() => {
    if (!enabled) return;

    intervalRef.current = setInterval(() => {
      setData(prev => {
        const newTemp = clamp(prev.temperature + randomDelta(0.4), 18, 42);
        const newHumidity = clamp(prev.humidity + randomDelta(1.5), 40, 90);
        const newCo2 = clamp(prev.co2 + randomDelta(15), 300, 800);
        const newVentilation = clamp(prev.ventilation + randomDelta(3), 50, 100);

        const newTempHistory = [...prev.tempHistory.slice(-23), parseFloat(newTemp.toFixed(1))];
        const newHumHistory = [...prev.humidityHistory.slice(-23), parseFloat(newHumidity.toFixed(1))];

        return {
          ...prev,
          temperature: parseFloat(newTemp.toFixed(1)),
          humidity: parseFloat(newHumidity.toFixed(1)),
          co2: Math.round(newCo2),
          ventilation: Math.round(newVentilation),
          tempHistory: newTempHistory,
          humidityHistory: newHumHistory,
        };
      });
    }, 3000);

    return () => {
      if (intervalRef.current) clearInterval(intervalRef.current);
    };
  }, [enabled]);

  return data;
}
