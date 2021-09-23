// Next.js API route support: https://nextjs.org/docs/api-routes/introduction
import type { NextApiRequest, NextApiResponse } from 'next';
import { Data } from '../../service/types';

let msgCount = 0;

export default function handler(
  req: NextApiRequest,
  res: NextApiResponse<Data>
): void {

  const responseMessage: Data = {
    greeting: process.env.BLUE_GREEN_CANARY_MESSAGE || 'Hello',
    count: msgCount++,
    pod: process.env.MY_POD || 'localhost',
    color: process.env.BLUE_GREEN_CANARY_COLOR || 'blue',
    textColor: process.env.TEXT_COLOR || 'whitesmoke',
    userAgent: req.headers['user-agent'] || 'unknown'
  };
  res.status(200).json(responseMessage);
}
