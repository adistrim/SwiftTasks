import express, { Request, Response } from 'express';

const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req: Request, res: Response) => {
    res.send('TypeScript Express server test');
});

app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
