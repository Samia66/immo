import { PaginationQuery } from '../../../core/models';
import { RoleName } from '../../../core/models/enums';
import { Permission, Role, User } from '../../../core/models/user.model';

export interface UserQuery extends PaginationQuery {
  role?: RoleName;
  isActive?: boolean;
  search?: string;
}

export interface CreateUserDto {
  email: string;
  firstName: string;
  lastName: string;
  phone?: string;
  roleId: string;
}

export type UpdateUserDto = Partial<Omit<CreateUserDto, 'email'>>;

export type { Role, Permission, User };
