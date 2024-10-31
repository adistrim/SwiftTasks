import { Router, Request, Response } from 'express';
import { User } from '../models/user.model';
import jwt from 'jsonwebtoken';
import { z } from 'zod';
import { authMiddleware, AuthRequest } from '../middleware/auth.middleware';

const router = Router();

const registerSchema = z.object({
    name: z.string().min(2),
    email: z.string().email(),
    password: z.string().min(6)
});

type RegisterBody = z.infer<typeof registerSchema>;

interface LoginBody {
    email: string;
    password: string;
}

router.post(
    '/register',
    async (req: Request<{}, {}, RegisterBody>, res: Response): Promise<any> => {
        try {
            const { name, email, password } = registerSchema.parse(req.body);

            const existingUser = await User.findOne({ email });
            if (existingUser) {
                return res.status(400).json({ message: 'Email already registered' });
            }

            const user = new User({ name, email, password });
            await user.save();

            const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET!);
            res.status(201).json({ token });
        } catch (error) {
            if (error instanceof z.ZodError) {
                return res.status(400).json({ message: 'Invalid input', errors: error.errors });
            }
            res.status(500).json({ message: 'Server error' });
        }
    }
);

router.post(
    '/login',
    async (req: Request<{}, {}, LoginBody>, res: Response): Promise<any> => {
        try {
            const { email, password } = req.body;

            const user = await User.findOne({ email });
            if (!user) {
                return res.status(400).json({ message: 'Invalid credentials' });
            }

            const isMatch = await user.comparePassword(password);
            if (!isMatch) {
                return res.status(400).json({ message: 'Invalid credentials' });
            }

            const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET!);

            res.json({ token, name: user.name });
        } catch (error) {
            res.status(500).json({ message: 'Server error' });
        }
    }
);

router.get(
    '/token-check',
    authMiddleware as any,
    async (req: AuthRequest, res: Response): Promise<any> => {
        try {
            const user = await User.findById(req.userId);
            if (!user) {
                return res.status(404).json({ message: 'User not found' });
            }
            res.json({ message: 'Token is valid', user: { name: user.name, email: user.email } });
        } catch (error) {
            res.status(500).json({ message: 'Server error' });
        }
    }
);

export default router;
