import { NotificationChannel, NotificationType } from './enums';

export interface AppNotification {
  id: string;
  organizationId: string;
  userId: string;
  type: NotificationType;
  channel: NotificationChannel;
  title: string;
  message: string;
  isRead: boolean;
  metadata?: Record<string, unknown> | null;
  createdAt: string;
}
