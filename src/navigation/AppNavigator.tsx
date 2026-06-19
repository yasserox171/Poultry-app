import React from 'react';
import { View, StyleSheet, Animated } from 'react-native';
import { NavigationContainer } from '@react-navigation/native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../constants/colors';
import HomeScreen from '../screens/HomeScreen';
import MonitoringScreen from '../screens/MonitoringScreen';
import FlockScreen from '../screens/FlockScreen';
import ReportsScreen from '../screens/ReportsScreen';
import StoreScreen from '../screens/StoreScreen';
import CommunityScreen from '../screens/CommunityScreen';

const Tab = createBottomTabNavigator();

interface TabIconProps {
  name: keyof typeof Ionicons.glyphMap;
  focused: boolean;
  color: string;
  size: number;
}

function TabIcon({ name, focused, color, size }: TabIconProps) {
  return (
    <View style={focused ? styles.activeIconWrap : undefined}>
      <Ionicons name={name} size={size} color={color} />
    </View>
  );
}

export default function AppNavigator() {
  return (
    <NavigationContainer>
      <Tab.Navigator
        initialRouteName="Home"
        screenOptions={{
          headerShown: false,
          tabBarStyle: styles.tabBar,
          tabBarActiveTintColor: Colors.primary,
          tabBarInactiveTintColor: Colors.tabInactive,
          tabBarLabelStyle: styles.tabLabel,
          tabBarItemStyle: styles.tabItem,
        }}
      >
        <Tab.Screen
          name="Home"
          component={HomeScreen}
          options={{
            title: 'الرئيسية',
            tabBarIcon: ({ focused, color, size }) => (
              <TabIcon name={focused ? 'home' : 'home-outline'} focused={focused} color={color} size={size} />
            ),
          }}
        />
        <Tab.Screen
          name="Monitoring"
          component={MonitoringScreen}
          options={{
            title: 'المراقبة',
            tabBarIcon: ({ focused, color, size }) => (
              <TabIcon name={focused ? 'pulse' : 'pulse-outline'} focused={focused} color={color} size={size} />
            ),
          }}
        />
        <Tab.Screen
          name="Flock"
          component={FlockScreen}
          options={{
            title: 'قطيعي',
            tabBarIcon: ({ focused, color, size }) => (
              <TabIcon name={focused ? 'egg' : 'egg-outline'} focused={focused} color={color} size={size} />
            ),
          }}
        />
        <Tab.Screen
          name="Reports"
          component={ReportsScreen}
          options={{
            title: 'التقارير',
            tabBarIcon: ({ focused, color, size }) => (
              <TabIcon name={focused ? 'bar-chart' : 'bar-chart-outline'} focused={focused} color={color} size={size} />
            ),
          }}
        />
        <Tab.Screen
          name="Store"
          component={StoreScreen}
          options={{
            title: 'المتجر',
            tabBarIcon: ({ focused, color, size }) => (
              <TabIcon name={focused ? 'storefront' : 'storefront-outline'} focused={focused} color={color} size={size} />
            ),
          }}
        />
        <Tab.Screen
          name="Community"
          component={CommunityScreen}
          options={{
            title: 'المجتمع',
            tabBarIcon: ({ focused, color, size }) => (
              <TabIcon name={focused ? 'people' : 'people-outline'} focused={focused} color={color} size={size} />
            ),
          }}
        />
      </Tab.Navigator>
    </NavigationContainer>
  );
}

const styles = StyleSheet.create({
  tabBar: {
    backgroundColor: Colors.cardBg,
    borderTopWidth: 0,
    elevation: 20,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: -4 },
    shadowOpacity: 0.08,
    shadowRadius: 12,
    height: 64,
    paddingBottom: 8,
    paddingTop: 4,
  },
  tabLabel: {
    fontSize: 10,
    fontWeight: '700',
    marginTop: 2,
  },
  tabItem: {
    paddingVertical: 4,
  },
  activeIconWrap: {
    backgroundColor: Colors.primary + '18',
    borderRadius: 10,
    padding: 4,
    minWidth: 32,
    alignItems: 'center',
  },
});
