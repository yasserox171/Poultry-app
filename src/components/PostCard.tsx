import React, { useState, useRef } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Animated } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../constants/colors';

interface Post {
  id: string;
  user: { name: string; avatar: string; location: string };
  content: string;
  likes: number;
  comments: number;
  time: string;
  liked: boolean;
  tag: string;
}

export default function PostCard({ post }: { post: Post }) {
  const [liked, setLiked] = useState(post.liked);
  const [likes, setLikes] = useState(post.likes);
  const heartAnim = useRef(new Animated.Value(1)).current;

  const handleLike = () => {
    setLiked(prev => {
      setLikes(l => l + (prev ? -1 : 1));
      return !prev;
    });
    Animated.sequence([
      Animated.timing(heartAnim, { toValue: 1.4, duration: 120, useNativeDriver: true }),
      Animated.spring(heartAnim, { toValue: 1, useNativeDriver: true }),
    ]).start();
  };

  return (
    <View style={styles.card}>
      <View style={styles.header}>
        <Text style={styles.avatar}>{post.user.avatar}</Text>
        <View style={styles.userInfo}>
          <Text style={styles.userName}>{post.user.name}</Text>
          <Text style={styles.userLocation}>
            <Ionicons name="location-outline" size={11} color={Colors.textMuted} /> {post.user.location} · منذ {post.time}
          </Text>
        </View>
        <View style={styles.tagBadge}>
          <Text style={styles.tagText}>{post.tag}</Text>
        </View>
      </View>
      <Text style={styles.content}>{post.content}</Text>
      <View style={styles.footer}>
        <TouchableOpacity style={styles.action} onPress={handleLike}>
          <Animated.View style={{ transform: [{ scale: heartAnim }] }}>
            <Ionicons
              name={liked ? 'heart' : 'heart-outline'}
              size={20}
              color={liked ? Colors.danger : Colors.textMuted}
            />
          </Animated.View>
          <Text style={[styles.actionText, liked && { color: Colors.danger }]}>{likes}</Text>
        </TouchableOpacity>
        <TouchableOpacity style={styles.action}>
          <Ionicons name="chatbubble-outline" size={18} color={Colors.textMuted} />
          <Text style={styles.actionText}>{post.comments}</Text>
        </TouchableOpacity>
        <TouchableOpacity style={styles.action}>
          <Ionicons name="share-social-outline" size={18} color={Colors.textMuted} />
          <Text style={styles.actionText}>شارك</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: Colors.cardBg,
    borderRadius: 16,
    padding: 16,
    marginBottom: 12,
    shadowColor: Colors.shadow,
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 6,
    elevation: 2,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 10,
  },
  avatar: {
    fontSize: 30,
    marginRight: 10,
  },
  userInfo: {
    flex: 1,
  },
  userName: {
    fontSize: 14,
    fontWeight: '700',
    color: Colors.textPrimary,
  },
  userLocation: {
    fontSize: 11,
    color: Colors.textMuted,
    marginTop: 2,
  },
  tagBadge: {
    backgroundColor: Colors.surface,
    borderRadius: 10,
    paddingHorizontal: 8,
    paddingVertical: 3,
    borderWidth: 1,
    borderColor: Colors.border,
  },
  tagText: {
    fontSize: 11,
    color: Colors.primary,
    fontWeight: '600',
  },
  content: {
    fontSize: 14,
    color: Colors.textPrimary,
    lineHeight: 22,
    marginBottom: 12,
    textAlign: 'right',
  },
  footer: {
    flexDirection: 'row',
    borderTopWidth: 1,
    borderTopColor: Colors.border,
    paddingTop: 10,
    gap: 20,
  },
  action: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 5,
  },
  actionText: {
    fontSize: 13,
    color: Colors.textMuted,
    fontWeight: '600',
  },
});
