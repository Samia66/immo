import { Injectable } from '@nestjs/common';
import { Notification } from '@prisma/client';

/** IN_APP is the only fully-implemented channel for this MVP pass (spec §12: "Notifications in-app uniquement"). */
@Injectable()
export class InAppChannel {
  // Delivery is implicit: the Notification row itself IS the in-app notification, already
  // persisted by NotificationsService before dispatch. Nothing further to do here.
  async deliver(notification: Notification): Promise<void> {
    void notification;
  }
}
