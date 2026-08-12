import { Injectable, NotFoundException } from '@nestjs/common';
import { NotificationChannel, NotificationType, Prisma } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';
import { PaginatedResponseDto } from '../../common/dto';
import { QueryNotificationDto } from './dto';
import { InAppChannel } from './channels/inapp.channel';
import { EmailChannel } from './channels/email.channel';
import { SmsChannel } from './channels/sms.channel';

export interface NotifyInput {
  organizationId: string;
  userId?: string | null;
  type: NotificationType;
  title: string;
  message: string;
  channel?: NotificationChannel;
  metadata?: Record<string, unknown>;
}

@Injectable()
export class NotificationsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly inApp: InAppChannel,
    private readonly email: EmailChannel,
    private readonly sms: SmsChannel,
  ) {}

  /** Creates + dispatches a notification. No-op if there is no recipient user (e.g. tenant without a portal account). */
  async notify(input: NotifyInput) {
    if (!input.userId) return null;

    const notification = await this.prisma.notification.create({
      data: {
        organization: { connect: { id: input.organizationId } },
        userId: input.userId,
        type: input.type,
        channel: input.channel ?? 'IN_APP',
        title: input.title,
        message: input.message,
        metadata: input.metadata as Prisma.InputJsonValue | undefined,
      },
    });

    switch (notification.channel) {
      case 'EMAIL':
        await this.email.deliver(notification);
        break;
      case 'SMS':
        await this.sms.deliver(notification);
        break;
      default:
        await this.inApp.deliver(notification);
    }

    return notification;
  }

  async findAll(userId: string, query: QueryNotificationDto) {
    const where: Prisma.NotificationWhereInput = { userId };
    if (query.isRead !== undefined) where.isRead = query.isRead === 'true';

    const [items, total] = await Promise.all([
      this.prisma.notification.findMany({
        where,
        skip: (query.page - 1) * query.limit,
        take: query.limit,
        orderBy: { createdAt: 'desc' },
      }),
      this.prisma.notification.count({ where }),
    ]);

    return new PaginatedResponseDto(items, total, query.page, query.limit);
  }

  async markRead(userId: string, id: string) {
    const notification = await this.prisma.notification.findFirst({ where: { id, userId } });
    if (!notification) throw new NotFoundException('Notification introuvable.');
    return this.prisma.notification.update({ where: { id }, data: { isRead: true } });
  }

  async markAllRead(userId: string) {
    await this.prisma.notification.updateMany({ where: { userId, isRead: false }, data: { isRead: true } });
    return { success: true };
  }

  async unreadCount(userId: string) {
    const count = await this.prisma.notification.count({ where: { userId, isRead: false } });
    return { count };
  }
}
