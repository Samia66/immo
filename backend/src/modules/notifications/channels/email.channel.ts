import { Injectable } from '@nestjs/common';
import { Notification } from '@prisma/client';
import { logStubEmail } from '../../../common/utils/mailer.util';
import { PrismaService } from '../../../prisma/prisma.service';

/**
 * TODO (V2 scope, see spec §12): plug a real SMTP transport for automated email notifications
 * (rappels, retards, expirations). For this MVP pass we log the "sent" email instead.
 */
@Injectable()
export class EmailChannel {
  constructor(private readonly prisma: PrismaService) {}

  async deliver(notification: Notification): Promise<void> {
    const user = await this.prisma.user.findUnique({ where: { id: notification.userId } });
    if (!user) return;
    logStubEmail(user.email, notification.title, notification.message);
  }
}
