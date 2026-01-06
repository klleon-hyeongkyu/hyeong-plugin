# Good Code Examples

## 깔끔한 함수

```typescript
/**
 * 사용자 정보를 조회합니다.
 * @param userId - 사용자 ID
 * @returns 사용자 정보 또는 null
 */
async function getUser(userId: string): Promise<User | null> {
  if (!userId) {
    return null;
  }

  try {
    const user = await userRepository.findById(userId);
    return user ?? null;
  } catch (error) {
    logger.error('Failed to get user', { userId, error });
    return null;
  }
}
```

## 명확한 조건문

```typescript
const canAccessResource = (user: User, resource: Resource): boolean => {
  const isOwner = resource.ownerId === user.id;
  const isAdmin = user.role === 'admin';
  const isPublic = resource.visibility === 'public';

  return isOwner || isAdmin || isPublic;
};
```

## 재사용 가능한 컴포넌트

```tsx
interface ButtonProps {
  variant: 'primary' | 'secondary';
  size: 'small' | 'medium' | 'large';
  children: React.ReactNode;
  onClick?: () => void;
}

const Button: React.FC<ButtonProps> = ({
  variant,
  size,
  children,
  onClick,
}) => {
  return (
    <button
      className={cn(buttonVariants({ variant, size }))}
      onClick={onClick}
    >
      {children}
    </button>
  );
};
```
