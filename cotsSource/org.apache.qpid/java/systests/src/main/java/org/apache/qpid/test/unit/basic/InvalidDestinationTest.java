/*
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *
 */

package org.apache.qpid.test.unit.basic;

import org.apache.qpid.client.AMQConnection;
import org.apache.qpid.client.AMQQueue;
import org.apache.qpid.test.utils.QpidTestCase;

import javax.jms.Session;
import javax.jms.QueueSession;
import javax.jms.Queue;
import javax.jms.QueueSender;
import javax.jms.TextMessage;
import javax.jms.InvalidDestinationException;

public class InvalidDestinationTest extends QpidTestCase
{
    private AMQConnection _connection;

    protected void setUp() throws Exception
    {
        super.setUp();
        _connection = (AMQConnection) getConnection("guest", "guest");
    }

    protected void tearDown() throws Exception
    {
        _connection.close();
        super.tearDown();
    }



    public void testInvalidDestination() throws Exception
    {
        Queue invalidDestination = new AMQQueue("amq.direct","unknownQ");
        AMQQueue validDestination = new AMQQueue("amq.direct","knownQ");
        QueueSession queueSession = _connection.createQueueSession(false, Session.AUTO_ACKNOWLEDGE);

        // This is the only easy way to create and bind a queue from the API :-(
        queueSession.createConsumer(validDestination);

        QueueSender sender = queueSession.createSender(invalidDestination);
        TextMessage msg = queueSession.createTextMessage("Hello");
        try
        {
            sender.send(msg);
            fail("Expected InvalidDestinationException");
        }
        catch (InvalidDestinationException ex)
        {
            // pass
        }
        sender.close();

        sender = queueSession.createSender(null);
        invalidDestination = new AMQQueue("amq.direct","unknownQ");

        try
        {
            sender.send(invalidDestination,msg);
            fail("Expected InvalidDestinationException");
        }
        catch (InvalidDestinationException ex)
        {
            // pass
        }
        sender.send(validDestination,msg);
        sender.close();
        validDestination = new AMQQueue("amq.direct","knownQ");
        sender = queueSession.createSender(validDestination);
        sender.send(msg);




    }


    public static junit.framework.Test suite()
    {

        return new junit.framework.TestSuite(InvalidDestinationTest.class);
    }
}
