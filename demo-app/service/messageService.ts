import useSwr from 'swr';
import { MessageData } from './types';

const fetcher = (url:string) => fetch(url).then((res) => res.json());

export function Messages():MessageData {
  const refreshInterval:number = parseInt(process.env.REFRESH_INTERVAL || '1000');
  const { data,error } = useSwr('/api',fetcher,{ refreshInterval:refreshInterval });

  //console.log(`Data ${JSON.stringify(data)}`);

  return {
    isLoading: !error && !data,
    message: data,
    isError: error
  };
}
