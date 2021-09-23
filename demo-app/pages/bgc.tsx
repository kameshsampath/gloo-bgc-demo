import React from 'react';
import type { NextPage } from 'next';
import {
  Box,
  StatGroup,
  Stat,
  StatLabel,
  StatNumber,
  StatHelpText,
  Text,
} from '@chakra-ui/react';
import { Data } from '../service/types';

type Props = {
  message: Data
}

const BGC: NextPage<Props> = ({message}) => {
  return (
    <Box>
      <StatGroup>
        <Stat>
          <StatLabel>Message Count</StatLabel>
          <StatNumber>{message?.count}</StatNumber>
        </Stat>
        <Stat>
          <StatLabel>Source</StatLabel>
          <StatNumber>{message?.pod}</StatNumber>
          <StatHelpText>The source of the message pod, vm etc.,</StatHelpText>
        </Stat>
      </StatGroup>
      <Text 
        fontSize="xl" 
        fontWeight="bold" 
        color={message?.textColor}
        background={message?.color}
        align="center">
        {message?.greeting}
      </Text>
    </Box>
  );
};

export default BGC;
