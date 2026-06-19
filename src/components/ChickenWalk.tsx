import React, { useEffect, useRef } from 'react';
import { Animated, View, StyleSheet } from 'react-native';
import Svg, { G, Path, Circle, Ellipse } from 'react-native-svg';

interface Props {
  width?: number;
  speed?: number;
  color?: string;
  flipped?: boolean;
}

export default function ChickenWalk({ width = 340, speed = 3000, color = '#FFFFFF', flipped = false }: Props) {
  const posX = useRef(new Animated.Value(flipped ? width : -60)).current;
  const bodyBob = useRef(new Animated.Value(0)).current;
  const wingFlap = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    // Walk from one side to the other, then restart
    const walkLoop = Animated.loop(
      Animated.sequence([
        Animated.timing(posX, {
          toValue: flipped ? -80 : width + 20,
          duration: speed,
          useNativeDriver: true,
        }),
        Animated.timing(posX, {
          toValue: flipped ? width : -80,
          duration: 0,
          useNativeDriver: true,
        }),
      ])
    );

    const bobLoop = Animated.loop(
      Animated.sequence([
        Animated.timing(bodyBob, { toValue: -3, duration: 200, useNativeDriver: true }),
        Animated.timing(bodyBob, { toValue: 0, duration: 200, useNativeDriver: true }),
      ])
    );

    const wingLoop = Animated.loop(
      Animated.sequence([
        Animated.timing(wingFlap, { toValue: 1, duration: 500, useNativeDriver: true }),
        Animated.timing(wingFlap, { toValue: 0, duration: 500, useNativeDriver: true }),
      ])
    );

    walkLoop.start();
    bobLoop.start();
    wingLoop.start();

    return () => {
      walkLoop.stop();
      bobLoop.stop();
      wingLoop.stop();
    };
  }, []);

  return (
    <View style={[styles.container, { width }]} pointerEvents="none">
      <Animated.View style={{ transform: [{ translateX: posX }, { translateY: bodyBob }] }}>
        <Svg width={60} height={60} viewBox="0 0 60 60">
          {/* Body */}
          <Ellipse cx="28" cy="34" rx="14" ry="10" fill={color} opacity="0.9" />
          {/* Head */}
          <Circle cx="42" cy="22" r="8" fill={color} opacity="0.9" />
          {/* Beak */}
          <Path d="M49 22 L54 21 L49 24 Z" fill="#FFB300" />
          {/* Comb */}
          <Path d="M40 14 Q42 10 44 14 Q46 9 48 14" fill="#D32F2F" strokeWidth="0" />
          {/* Eye */}
          <Circle cx="44" cy="20" r="1.5" fill="#1A1A1A" />
          {/* Wing */}
          <Ellipse cx="26" cy="32" rx="8" ry="5" fill={color} opacity="0.7" />
          {/* Tail feathers */}
          <Path d="M14 28 Q8 24 10 32 Q6 26 12 36" stroke={color} strokeWidth="3" fill="none" strokeLinecap="round" />
          {/* Legs — use static alternating positions driven by a counter */}
          <Path d="M26 44 L28 56" stroke="#FFB300" strokeWidth="2.5" strokeLinecap="round" />
          <Path d="M28 56 L24 60 M28 56 L30 61" stroke="#FFB300" strokeWidth="2" strokeLinecap="round" />
          <Path d="M32 44 L30 56" stroke="#FFB300" strokeWidth="2.5" strokeLinecap="round" />
          <Path d="M30 56 L26 61 M30 56 L34 60" stroke="#FFB300" strokeWidth="2" strokeLinecap="round" />
        </Svg>
      </Animated.View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    height: 60,
    overflow: 'hidden',
  },
});
