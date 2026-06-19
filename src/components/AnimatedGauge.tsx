import React, { useEffect, useRef } from 'react';
import { View, Text, Animated, StyleSheet } from 'react-native';
import Svg, { Circle, Path, G, Text as SvgText } from 'react-native-svg';
import { Colors } from '../constants/colors';

interface Props {
  value: number;
  min?: number;
  max?: number;
  unit?: string;
  label?: string;
  size?: number;
  dangerAbove?: number;
  warnAbove?: number;
}

const AnimatedCircle = Animated.createAnimatedComponent(Circle);

function getColor(value: number, warnAbove: number, dangerAbove: number) {
  if (value >= dangerAbove) return Colors.gaugeDanger;
  if (value >= warnAbove) return Colors.gaugeWarn;
  return Colors.gaugeGood;
}

function getStatusLabel(value: number, warnAbove: number, dangerAbove: number) {
  if (value >= dangerAbove) return 'حرج';
  if (value >= warnAbove) return 'تحذير';
  return 'مثالي';
}

export default function AnimatedGauge({
  value,
  min = 0,
  max = 50,
  unit = '°م',
  label = 'درجة الحرارة',
  size = 200,
  dangerAbove = 35,
  warnAbove = 30,
}: Props) {
  const animatedValue = useRef(new Animated.Value(value)).current;
  const pulseAnim = useRef(new Animated.Value(1)).current;

  const radius = (size / 2) * 0.78;
  const cx = size / 2;
  const cy = size / 2;
  const circumference = 2 * Math.PI * radius;
  const sweepPct = 0.75; // 270 degrees arc
  const dashArray = circumference * sweepPct;

  useEffect(() => {
    Animated.timing(animatedValue, {
      toValue: value,
      duration: 800,
      useNativeDriver: false,
    }).start();

    // Pulse animation for the center dot
    Animated.loop(
      Animated.sequence([
        Animated.timing(pulseAnim, { toValue: 1.2, duration: 800, useNativeDriver: true }),
        Animated.timing(pulseAnim, { toValue: 1, duration: 800, useNativeDriver: true }),
      ])
    ).start();
  }, [value]);

  const dashOffset = animatedValue.interpolate({
    inputRange: [min, max],
    outputRange: [dashArray, 0],
    extrapolate: 'clamp',
  });

  const color = getColor(value, warnAbove, dangerAbove);
  const statusLabel = getStatusLabel(value, warnAbove, dangerAbove);

  // Arc path: starts at bottom-left (225°), sweeps 270°
  const startAngle = 135;
  const endAngle = 135 + 270;
  function polarToCartesian(angle: number) {
    const a = ((angle - 90) * Math.PI) / 180;
    return {
      x: cx + radius * Math.cos(a),
      y: cy + radius * Math.sin(a),
    };
  }
  const start = polarToCartesian(startAngle);
  const end = polarToCartesian(endAngle - 0.01);
  const arcPath = `M ${start.x} ${start.y} A ${radius} ${radius} 0 1 1 ${end.x} ${end.y}`;

  const valuePct = Math.min(Math.max((value - min) / (max - min), 0), 1);
  const fillAngle = startAngle + valuePct * 270;
  const fillEnd = polarToCartesian(fillAngle);
  const largeArc = valuePct * 270 > 180 ? 1 : 0;
  const fillPath = `M ${start.x} ${start.y} A ${radius} ${radius} 0 ${largeArc} 1 ${fillEnd.x} ${fillEnd.y}`;

  return (
    <View style={[styles.container, { width: size, height: size }]}>
      <Svg width={size} height={size}>
        {/* Background arc */}
        <Path
          d={arcPath}
          fill="none"
          stroke={Colors.gaugeBg}
          strokeWidth={14}
          strokeLinecap="round"
        />
        {/* Filled arc */}
        <Path
          d={fillPath}
          fill="none"
          stroke={color}
          strokeWidth={14}
          strokeLinecap="round"
        />
        {/* Tick marks */}
        {[0, 0.25, 0.5, 0.75, 1].map((pct, i) => {
          const angle = startAngle + pct * 270;
          const inner = polarToCartesian(angle);
          const outerRadius = radius + 10;
          const outer = (() => {
            const a = ((angle - 90) * Math.PI) / 180;
            return { x: cx + outerRadius * Math.cos(a), y: cy + outerRadius * Math.sin(a) };
          })();
          return (
            <Path
              key={i}
              d={`M ${inner.x} ${inner.y} L ${outer.x} ${outer.y}`}
              stroke={Colors.textMuted}
              strokeWidth={2}
            />
          );
        })}
        {/* Center pulse dot */}
        <Circle cx={cx} cy={cy} r={6} fill={color} />
      </Svg>

      {/* Center text overlay */}
      <View style={[styles.centerText, { width: size, height: size }]}>
        <Text style={[styles.value, { color }]}>
          {value.toFixed(1)}
        </Text>
        <Text style={styles.unit}>{unit}</Text>
        <View style={[styles.statusBadge, { backgroundColor: color + '22', borderColor: color }]}>
          <Text style={[styles.statusText, { color }]}>{statusLabel}</Text>
        </View>
      </View>

      {/* Label below */}
      <Text style={styles.label}>{label}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  centerText: {
    position: 'absolute',
    alignItems: 'center',
    justifyContent: 'center',
    top: 0,
    left: 0,
  },
  value: {
    fontSize: 38,
    fontWeight: '800',
    marginTop: 10,
  },
  unit: {
    fontSize: 16,
    color: Colors.textSecondary,
    marginTop: -4,
  },
  statusBadge: {
    marginTop: 6,
    paddingHorizontal: 10,
    paddingVertical: 3,
    borderRadius: 12,
    borderWidth: 1,
  },
  statusText: {
    fontSize: 12,
    fontWeight: '700',
  },
  label: {
    position: 'absolute',
    bottom: 8,
    fontSize: 13,
    color: Colors.textSecondary,
    fontWeight: '600',
  },
});
