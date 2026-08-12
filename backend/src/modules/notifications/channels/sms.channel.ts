import { Injectable, Logger } from '@nestjs/common';
import { Notification } from '@prisma/client';

/**
 * TODO (V3 scope, see spec §12): plug a real SMS gateway (configurable provider).
 * For this MVP pass we log the "sent" SMS instead.
 */
@Injectable()
export class SmsChannel {
  private readonly logger = new Logger('SmsChannelStub');

  async deliver(notification: Notification): Promise<void> {
    this.logger.log(`[STUB SMS] userId=${notification.userId} "${notification.title}": ${notification.message}`);
  }
}
