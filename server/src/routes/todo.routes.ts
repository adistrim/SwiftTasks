import { Router, Response } from 'express';
import { Todo } from '../models/todo.model';
import { authMiddleware, AuthRequest } from '../middleware/auth.middleware';
import { z } from 'zod';

const router = Router();

router.use(authMiddleware as any);

const todoSchema = z.object({
    title: z.string().min(1)
});

type TodoBody = z.infer<typeof todoSchema>;

interface TodoParams {
    id: string;
}

// all todos
router.get(
    '/',
    async (req: AuthRequest, res: Response) => {
        try {
            const todos = await Todo.find({ userId: req.userId });
            res.json(todos);
        } catch (error) {
            res.status(500).json({ message: 'Server error' });
        }
    }
);

// new todo
router.post(
    '/',
    async (req: AuthRequest<{}, {}, TodoBody>, res: Response):Promise<any> => {
        try {
            const { title } = todoSchema.parse(req.body);

            const todo = new Todo({
                userId: req.userId,
                title,
                isCompleted: false
            });

            await todo.save();
            res.status(201).json(todo);
        } catch (error) {
            if (error instanceof z.ZodError) {
                return res.status(400).json({ message: 'Invalid input', errors: error.errors });
            }
            res.status(500).json({ message: 'Server error' });
        }
    }
);

// Toggle todo completion (true/false)
router.patch(
    '/:id',
    async (req: AuthRequest<TodoParams>, res: Response):Promise<any> => {
        try {
            const todo = await Todo.findOne({ _id: req.params.id, userId: req.userId });

            if (!todo) {
                return res.status(404).json({ message: 'Todo not found' });
            }

            todo.isCompleted = !todo.isCompleted;
            await todo.save();

            res.json(todo);
        } catch (error) {
            res.status(500).json({ message: 'Server error' });
        }
    }
);

// Delete todo
router.delete(
    '/:id',
    async (req: AuthRequest<TodoParams>, res: Response):Promise<any> => {
        try {
            const todo = await Todo.findOneAndDelete({ _id: req.params.id, userId: req.userId });

            if (!todo) {
                return res.status(404).json({ message: 'Todo not found' });
            }

            res.json({ message: 'Todo deleted' });
        } catch (error) {
            res.status(500).json({ message: 'Server error' });
        }
    }
);

export default router;
