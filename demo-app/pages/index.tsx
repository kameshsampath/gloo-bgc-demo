import { Alert, AlertIcon, AlertTitle, Container, Heading, StackDivider, VStack } from '@chakra-ui/react';
import type { NextPage } from 'next';
import MessagesLoading from '../components/loader';
import { Messages } from '../service/messageService';
import BGC from './bgc';

const Home: NextPage = () => {

  const { message, isLoading, isError } = Messages();

  if (isLoading) {
    return <MessagesLoading />;
  }

  if (isError) {
    return (
      <Alert status="error">
        <AlertIcon />
        <AlertTitle mr={2}>Error Loading Messages: {isError}</AlertTitle>
      </Alert>
    );
  }

  return (
    <Container >
      <VStack divider={<StackDivider borderColor="teal.200" />}
        spacing={4}
        align="stretch">
        <Heading as="h1" size="2xl" mb="2">
          Blue Green Canary
        </Heading>
        <BGC message={message}/>
      </VStack>
    </Container>
  );
};

export default Home;
