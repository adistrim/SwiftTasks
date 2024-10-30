import mongoose, { Document, Schema } from 'mongoose';

export interface ITodo extends Document {
    userId: mongoose.Types.ObjectId;
    title: string;
    isCompleted: boolean;
}

const todoSchema = new Schema({
    userId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    title: { type: String, required: true },
    isCompleted: { type: Boolean, default: false }
}, { timestamps: true });

export const Todo = mongoose.model<ITodo>('Todo', todoSchema);
